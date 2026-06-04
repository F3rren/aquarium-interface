/// Core service for fetching, caching, and streaming aquarium water parameters.
library;

import 'dart:async';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameters.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameter.dart';
import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/features/settings/data/alert_manager.dart';
import 'package:acquariumfe/features/parameters/data/manual_parameters_service.dart';
import 'package:acquariumfe/features/settings/data/notification_settings_service.dart';
import 'package:acquariumfe/features/maintenance/data/maintenance_task_service.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import 'package:acquariumfe/features/settings/data/app_locale_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/utils/retry_policy.dart';
import 'package:logger/logger.dart';

/// Single source of truth for aquarium water parameters.
///
/// **Responsibilities:**
/// - Fetches the current sensor parameters from
///   `GET /aquariums/{id}/parameters` with automatic retry via
///   [RetryPolicies.critical].
/// - Merges the sensor parameters (temperature, pH, salinity, ORP) with the
///   manually-entered parameters (calcium, magnesium, KH, nitrate, phosphate)
///   from [ManualParametersService].
/// - Caches the merged result in [_cachedParameters]; [getCachedParameters]
///   honours a configurable [maxAge] (default 5 minutes).
/// - Broadcasts merged parameter updates through [parametersStream].
/// - Optionally auto-refreshes on a configurable [Timer] interval via
///   [startAutoRefresh] / [stopAutoRefresh].
/// - Delegates alert evaluation to [AlertManager] via
///   [_checkAllParametersForAlerts] (can be disabled with
///   [setAutoCheckAlerts]).
///
/// **Mock fallback (opt-in):** [getCurrentParameters] propagates errors by
/// default. Pass `useMock: true` (dev/demo only) to return pre-defined typical
/// reef values instead of throwing — never enable it in production, as it
/// hides a dead backend behind plausible-looking "all good" data.
///
/// Call [setCurrentAquarium] before any fetch. Changing the aquarium
/// automatically propagates the ID to all dependent services
/// ([ManualParametersService], [NotificationSettingsService],
/// [MaintenanceTaskService], [TargetParametersService]) and invalidates the
/// cache.
class ParameterService {
  /// Creates a [ParameterService].
  ///
  /// [apiService] and [targetService] are the Riverpod-managed dependencies.
  /// The remaining collaborators ([alertManager], [manualService],
  /// [notificationService], [maintenanceService]) default to their shared
  /// singletons in production but can be injected in tests to isolate this
  /// service from global state.
  ///
  /// Obtain the shared instance via Riverpod ([parameterServiceProvider])
  /// rather than constructing directly.
  ParameterService(
    this._apiService,
    this._targetService, {
    AlertManager? alertManager,
    ManualParametersService? manualService,
    NotificationSettingsService? notificationService,
    MaintenanceTaskService? maintenanceService,
  })  : _alertManager = alertManager ?? AlertManager(),
        _manualService = manualService ?? ManualParametersService(),
        _notificationService =
            notificationService ?? NotificationSettingsService(),
        _maintenanceService =
            maintenanceService ?? MaintenanceTaskService();

  final ApiService _apiService;
  final TargetParametersService _targetService;
  final AlertManager _alertManager;
  final Logger _logger = Logger();
  final ManualParametersService _manualService;
  final NotificationSettingsService _notificationService;
  final MaintenanceTaskService _maintenanceService;

  /// ID of the currently selected aquarium.
  int? _currentid;

  /// Most-recently fetched and merged parameter set.
  AquariumParameters? _cachedParameters;

  /// Timestamp of the last successful fetch; used by [getCachedParameters].
  DateTime? _lastFetch;

  /// Periodic auto-refresh timer; `null` when auto-refresh is stopped.
  Timer? _refreshTimer;
  bool _isAutoRefreshEnabled = false;

  /// Broadcast stream that emits every time a fresh parameter set is received.
  final _parametersController =
      StreamController<AquariumParameters>.broadcast();

  /// Stream of merged [AquariumParameters]; subscribe to receive real-time
  /// updates whenever the service fetches new data.
  Stream<AquariumParameters> get parametersStream =>
      _parametersController.stream;

  /// Controls whether [_checkAllParametersForAlerts] is called after each
  /// successful fetch. Enabled by default.
  bool _autoCheckAlerts = true;

  /// Returns the current state of automatic alert checking.
  bool get autoCheckAlertsEnabled => _autoCheckAlerts;

  /// Enables or disables automatic alert evaluation after each fetch.
  void setAutoCheckAlerts(bool enabled) {
    _autoCheckAlerts = enabled;
  }

  /// Clears the parameter cache, forcing the next [getCurrentParameters] call
  /// to fetch fresh data from the backend.
  void invalidateCache() {
    _cachedParameters = null;
    _lastFetch = null;
  }

  /// Sets the active aquarium and propagates the ID to all dependent services.
  ///
  /// Invalidates the parameter cache when [id] differs from the current value.
  void setCurrentAquarium(int id) {
    if (_currentid != id) {
      _currentid = id;
      _cachedParameters = null;
      _lastFetch = null;

      _manualService.setCurrentAquarium(id);
      _notificationService.setCurrentAquarium(id);
      _maintenanceService.setCurrentAquarium(id);
      _targetService.setCurrentAquarium(id);
    }
  }

  /// Fetches and returns the current water parameters for the active aquarium
  /// (or [id] if supplied).
  ///
  /// The sensor parameters are fetched from
  /// `GET /aquariums/{id}/parameters` using [RetryPolicies.critical] (3 retries
  /// with exponential back-off). Manual parameters are loaded from
  /// [ManualParametersService] and overlay the sensor values for the five
  /// manually-tested parameters.
  ///
  /// Errors are propagated by default so the UI can show a real error state.
  /// Pass [useMock] `true` (dev/demo only) to return a hardcoded fallback with
  /// typical reef values instead of throwing — do not use it in production, as
  /// it masks a failing backend with plausible "all good" readings.
  ///
  /// Throws [NoAquariumSelectedException] when no aquarium is active and [id]
  /// is also `null`.
  Future<AquariumParameters> getCurrentParameters({
    int? id,
    bool useMock = false,
  }) async {
    final targetid = id ?? _currentid;

    if (targetid == null) {
      throw NoAquariumSelectedException(
        details:
            'Usa setCurrentAquarium() per selezionare una vasca prima di recuperare i parametri',
      );
    }

    try {
      final response = await _apiService.get(
        ApiEndpoints.parameters(targetid),
        retry: RetryPolicies.critical,
      );

      final Map<String, dynamic> parametersData;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List && data.isNotEmpty) {
            // If 'data' is an array, use the first element.
            parametersData = data[0] as Map<String, dynamic>;
          } else if (data is Map<String, dynamic>) {
            parametersData = data;
          } else {
            throw DataFormatException(
              'Formato data non valido dalla risposta API',
              details: 'Atteso oggetto o array, ricevuto: ${data.runtimeType}',
            );
          }
        } else {
          parametersData = response;
        }
      } else {
        throw DataFormatException(
          'Formato risposta non valido',
          details: 'Attesa mappa, ricevuto: ${response.runtimeType}',
        );
      }

      final parameters = AquariumParameters.fromJson(parametersData);

      // Merge manual parameters on top of sensor values.
      final manualParams = await _manualService.loadManualParameters();
      final completeParameters = AquariumParameters(
        temperature: parameters.temperature,
        ph: parameters.ph,
        salinity: parameters.salinity,
        orp: parameters.orp,
        calcium: manualParams['calcium'] ?? parameters.calcium,
        magnesium: manualParams['magnesium'] ?? parameters.magnesium,
        kh: manualParams['kh'] ?? parameters.kh,
        nitrate: manualParams['nitrate'] ?? parameters.nitrate,
        phosphate: manualParams['phosphate'] ?? parameters.phosphate,
        timestamp: parameters.timestamp,
      );

      _cachedParameters = completeParameters;
      _lastFetch = DateTime.now();
      _parametersController.add(completeParameters);

      if (_autoCheckAlerts) {
        await _checkAllParametersForAlerts(completeParameters);
      }

      return completeParameters;
    } on AppException {
      if (useMock) {
        return _getMockParameters();
      }
      rethrow;
    } catch (e) {
      if (useMock) {
        return _getMockParameters();
      }
      throw AppError(
        'Errore imprevisto durante il recupero dei parametri',
        details: e.toString(),
        originalError: e,
      );
    }
  }

  /// Returns the cached parameter set if it is younger than [maxAge].
  ///
  /// Returns `null` when the cache is empty or has expired.
  AquariumParameters? getCachedParameters({
    Duration maxAge = const Duration(minutes: 5),
  }) {
    if (_cachedParameters == null || _lastFetch == null) {
      return null;
    }

    final age = DateTime.now().difference(_lastFetch!);
    if (age > maxAge) {
      return null;
    }

    return _cachedParameters;
  }

  /// Returns historical parameter snapshots for the active aquarium (or [id]).
  ///
  /// Accepts optional [from] / [to] date range and a [limit] on the number of
  /// records. Returns an empty list rather than throwing on any error.
  ///
  /// The backend response can take two shapes:
  /// - `{"data": {"id": 1, "measurements": [...]}}` (new format)
  /// - `{"data": [{...}]}` or a bare array (legacy format)
  Future<List<AquariumParameters>> getParameterHistory({
    String? id,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    final targetid = id ?? _currentid;

    if (targetid == null) {
      return [];
    }

    try {
      final queryParams = <String, String>{};
      if (from != null) queryParams['from'] = from.toIso8601String();
      if (to != null) queryParams['to'] = to.toIso8601String();
      if (limit != null) queryParams['limit'] = limit.toString();

      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      final base = ApiEndpoints.parameterHistory(int.parse(targetid.toString()));
      final endpoint = query.isNotEmpty ? '$base?$query' : base;

      final response = await _apiService.get(endpoint);

      List<dynamic> historyJson;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          var dataValue = response['data'];

          if (dataValue is Map<String, dynamic>) {
            if (dataValue['id'].toString() == targetid &&
                dataValue['measurements'] != null) {
              historyJson = dataValue['measurements'] as List<dynamic>;
            } else {
              historyJson = [];
            }
          } else if (dataValue is List) {
            final aquariumData = dataValue.firstWhere(
              (item) => item['id'].toString() == targetid,
              orElse: () => null,
            );

            if (aquariumData != null && aquariumData['measurements'] != null) {
              historyJson = aquariumData['measurements'] as List<dynamic>;
            } else {
              historyJson = [];
            }
          } else {
            historyJson = [];
          }
        } else {
          historyJson = [];
        }
      } else if (response is List) {
        final aquariumData = response.firstWhere(
          (item) => item['id'].toString() == targetid,
          orElse: () => null,
        );

        if (aquariumData != null && aquariumData['measurements'] != null) {
          historyJson = aquariumData['measurements'] as List<dynamic>;
        } else {
          historyJson = [];
        }
      } else {
        historyJson = [];
      }

      return historyJson
          .map((json) => AquariumParameters.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } on AppException catch (e) {
      _logger.e('Errore recupero storico parametri', error: e);
      return [];
    } catch (e) {
      _logger.e('Errore imprevisto in getParametersHistory', error: e);
      return [];
    }
  }

  /// Returns `{timestamp, value}` pairs for a single [parameterName] over the
  /// requested [hours] duration, suitable for chart rendering.
  ///
  /// The time range is computed from today's calendar boundaries rather than
  /// exact [hours]:
  /// - 24 h → yesterday midnight to today midnight
  /// - 168 h (7 days) → 7 days ago midnight to today midnight
  /// - 720 h (30 days) → 30 days ago midnight to today midnight
  ///
  /// [parameterName] must be a backend key: `'temperature'`, `'ph'`,
  /// `'salinity'`, `'orp'`, `'calcium'`, `'magnesium'`, `'kh'`, `'nitrate'`,
  /// `'phosphate'`. The response field `item['value']` is used first, falling
  /// back to `item[parameterName]`. Returns an empty list on any error.
  Future<List<Map<String, dynamic>>> getParameterHistoryForChart({
    required int aquariumId,
    required String parameterName,
    required Duration hours,
  }) async {
    final now = DateTime.now();

    final DateTime from;
    final DateTime to = DateTime(now.year, now.month, now.day, 23, 59, 59);

    if (hours.inHours == 24) {
      from = DateTime(now.year, now.month, now.day - 1, 0, 0, 0);
    } else if (hours.inHours == 168) {
      from = DateTime(now.year, now.month, now.day - 7, 0, 0, 0);
    } else if (hours.inHours == 720) {
      from = DateTime(now.year, now.month, now.day - 30, 0, 0, 0);
    } else {
      from = now.subtract(hours);
    }

    try {
      final queryParams = <String, String>{
        'param': parameterName,
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      };

      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      final endpoint = '${ApiEndpoints.parameterHistory(aquariumId)}?$query';
      final response = await _apiService.get(endpoint);

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];
        if (data is List) {
          return data.map<Map<String, dynamic>>((item) {
            return {
              'timestamp':
                  item['timestamp'] ??
                  item['measuredAt'] ??
                  DateTime.now().toIso8601String(),
              'value': (item['value'] ?? item[parameterName] ?? 0).toDouble(),
            };
          }).toList();
        }
      }

      return [];
    } on AppException catch (e) {
      _logger.e('Errore recupero storico per grafico', error: e);
      return [];
    } catch (e) {
      _logger.e('Errore imprevisto in getParameterHistoryForChart', error: e);
      return [];
    }
  }

  /// Pushes a new [parameters] snapshot to the backend at `POST /parameters`
  /// and updates the cache and stream.
  Future<void> updateParameters(AquariumParameters parameters) async {
    await _apiService.post(ApiEndpoints.submitParameters, parameters.toJson());

    _cachedParameters = parameters;
    _parametersController.add(parameters);
  }

  /// Starts the periodic auto-refresh timer.
  ///
  /// The first fetch is immediate; subsequent fetches occur every [interval]
  /// (default 10 seconds). Calling this while auto-refresh is already running
  /// is a no-op.
  void startAutoRefresh({Duration interval = const Duration(seconds: 10)}) {
    if (_isAutoRefreshEnabled) return;

    _isAutoRefreshEnabled = true;

    unawaited(_autoRefreshTick());

    _refreshTimer = Timer.periodic(
      interval,
      (_) => unawaited(_autoRefreshTick()),
    );
  }

  /// Performs a single auto-refresh fetch. Errors are logged and swallowed so a
  /// transient backend failure neither crashes the app with an unhandled async
  /// error nor pushes stale/fake data onto [parametersStream] — the last known
  /// values simply remain until the next successful tick.
  Future<void> _autoRefreshTick() async {
    try {
      await getCurrentParameters();
    } catch (e) {
      _logger.w('Auto-refresh failed; keeping last known values', error: e);
    }
  }

  /// Stops and cancels the auto-refresh timer.
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _isAutoRefreshEnabled = false;
  }

  /// `true` when the auto-refresh timer is active.
  bool get isAutoRefreshEnabled => _isAutoRefreshEnabled;

  /// Returns hardcoded typical marine reef parameter values used as a mock
  /// fallback when the network is unavailable.
  AquariumParameters _getMockParameters() {
    return AquariumParameters(
      temperature: 25.0,
      ph: 8.20,
      salinity: 1.024,
      orp: 350.0,
      calcium: 420.0,
      magnesium: 1280.0,
      kh: 9.0,
      nitrate: 5.0,
      phosphate: 0.03,
      timestamp: DateTime.now(),
    );
  }

  /// Evaluates all nine parameters in [params] against the user's alert
  /// thresholds and delegates notification firing to [AlertManager].
  ///
  /// The four sensor parameters (temperature, pH, salinity, ORP) are always
  /// checked. The five manual parameters (calcium, magnesium, KH, nitrate,
  /// phosphate) are only checked when their value is non-null.
  ///
  /// Alert titles and messages are retrieved from [AppLocaleService] so that
  /// notifications are displayed in the user's selected language.
  Future<void> _checkAllParametersForAlerts(AquariumParameters params) async {
    final settings = await _notificationService.loadSettings();
    final localeService = AppLocaleService();

    await _alertManager.checkParameter(
      parameter: AquariumParameter.temperature,
      value: params.temperature,
      thresholds: settings.temperature,
      alertTitle: localeService.getAlertTitle(AquariumParameter.temperature),
      alertMessage: localeService.getAlertMessage(
        AquariumParameter.temperature,
        params.temperature > settings.temperature.max,
      ),
    );

    await _alertManager.checkParameter(
      parameter: AquariumParameter.ph,
      value: params.ph,
      thresholds: settings.ph,
      alertTitle: localeService.getAlertTitle(AquariumParameter.ph),
      alertMessage: localeService.getAlertMessage(
        AquariumParameter.ph,
        params.ph > settings.ph.max,
      ),
    );

    await _alertManager.checkParameter(
      parameter: AquariumParameter.salinity,
      value: params.salinity,
      thresholds: settings.salinity,
      alertTitle: localeService.getAlertTitle(AquariumParameter.salinity),
      alertMessage: localeService.getAlertMessage(
        AquariumParameter.salinity,
        params.salinity > settings.salinity.max,
      ),
    );

    await _alertManager.checkParameter(
      parameter: AquariumParameter.orp,
      value: params.orp,
      thresholds: settings.orp,
      alertTitle: localeService.getAlertTitle(AquariumParameter.orp),
      alertMessage: localeService.getAlertMessage(
        AquariumParameter.orp,
        params.orp > settings.orp.max,
      ),
    );

    if (params.calcium != null) {
      await _alertManager.checkParameter(
        parameter: AquariumParameter.calcium,
        value: params.calcium!,
        thresholds: settings.calcium,
        alertTitle: localeService.getAlertTitle(AquariumParameter.calcium),
        alertMessage: localeService.getAlertMessage(
          AquariumParameter.calcium,
          params.calcium! > settings.calcium.max,
        ),
      );
    }

    if (params.magnesium != null) {
      await _alertManager.checkParameter(
        parameter: AquariumParameter.magnesium,
        value: params.magnesium!,
        thresholds: settings.magnesium,
        alertTitle: localeService.getAlertTitle(AquariumParameter.magnesium),
        alertMessage: localeService.getAlertMessage(
          AquariumParameter.magnesium,
          params.magnesium! > settings.magnesium.max,
        ),
      );
    }

    if (params.kh != null) {
      await _alertManager.checkParameter(
        parameter: AquariumParameter.kh,
        value: params.kh!,
        thresholds: settings.kh,
        alertTitle: localeService.getAlertTitle(AquariumParameter.kh),
        alertMessage: localeService.getAlertMessage(
          AquariumParameter.kh,
          params.kh! > settings.kh.max,
        ),
      );
    }

    if (params.nitrate != null) {
      await _alertManager.checkParameter(
        parameter: AquariumParameter.nitrate,
        value: params.nitrate!,
        thresholds: settings.nitrate,
        alertTitle: localeService.getAlertTitle(AquariumParameter.nitrate),
        alertMessage: localeService.getAlertMessage(
          AquariumParameter.nitrate,
          params.nitrate! > settings.nitrate.max,
        ),
      );
    }

    if (params.phosphate != null) {
      await _alertManager.checkParameter(
        parameter: AquariumParameter.phosphate,
        value: params.phosphate!,
        thresholds: settings.phosphate,
        alertTitle: localeService.getAlertTitle(AquariumParameter.phosphate),
        alertMessage: localeService.getAlertMessage(
          AquariumParameter.phosphate,
          params.phosphate! > settings.phosphate.max,
        ),
      );
    }
  }

  /// Stops the auto-refresh timer and closes the parameters [StreamController].
  ///
  /// Must be called when the service is no longer needed to avoid memory leaks.
  void dispose() {
    stopAutoRefresh();
    _parametersController.close();
  }
}

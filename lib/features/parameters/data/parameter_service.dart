/// Core service for fetching aquarium water parameters and firing alerts.
library;

import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameters.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameter.dart';
import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/features/settings/data/alert_manager.dart';
import 'package:acquariumfe/features/parameters/data/manual_parameters_service.dart';
import 'package:acquariumfe/features/settings/data/notification_settings_service.dart';
import 'package:acquariumfe/features/settings/data/app_locale_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/utils/retry_policy.dart';
import 'package:acquariumfe/core/utils/app_logger.dart';

/// Single source of truth for aquarium water parameters.
///
/// **Responsibilities:**
/// - Fetches the current sensor parameters from
///   `GET /aquariums/{id}/parameters` with automatic retry via
///   [RetryPolicies.critical].
/// - Merges the sensor parameters (temperature, pH, salinity, ORP) with the
///   manually-entered parameters (calcium, magnesium, KH, nitrate, phosphate)
///   from [ManualParametersService].
/// - Delegates alert evaluation to [AlertManager] via
///   [_checkAllParametersForAlerts] (can be disabled with
///   [setAutoCheckAlerts]).
///
/// **Mock fallback (opt-in):** [getCurrentParameters] propagates errors by
/// default. Pass `useMock: true` (dev/demo only) to return pre-defined typical
/// reef values instead of throwing — never enable it in production, as it
/// hides a dead backend behind plausible-looking "all good" data.
///
/// Every fetch targets the aquarium passed to [getCurrentParameters]; the
/// service holds no mutable "current aquarium" state.
class ParameterService {
  /// Creates a [ParameterService].
  ///
  /// [apiService] is the Riverpod-managed dependency. The remaining
  /// collaborators ([alertManager], [manualService], [notificationService])
  /// default to fresh instances backed by the same [apiService], but the
  /// Riverpod provider injects the app-wide shared instances; tests can inject
  /// mocks to isolate this service.
  ///
  /// Obtain the shared instance via Riverpod ([parameterServiceProvider])
  /// rather than constructing directly.
  ParameterService(
    this._apiService, {
    AlertManager? alertManager,
    ManualParametersService? manualService,
    NotificationSettingsService? notificationService,
  })  : _alertManager = alertManager ?? AlertManager(),
        _manualService = manualService ?? ManualParametersService(_apiService),
        _notificationService =
            notificationService ?? NotificationSettingsService(_apiService);

  final ApiService _apiService;
  final AlertManager _alertManager;
  final ManualParametersService _manualService;
  final NotificationSettingsService _notificationService;

  /// Controls whether [_checkAllParametersForAlerts] is called after each
  /// successful fetch. Enabled by default.
  bool _autoCheckAlerts = true;

  /// Returns the current state of automatic alert checking.
  bool get autoCheckAlertsEnabled => _autoCheckAlerts;

  /// Enables or disables automatic alert evaluation after each fetch.
  void setAutoCheckAlerts(bool enabled) {
    _autoCheckAlerts = enabled;
  }

  /// Fetches and returns the current water parameters for aquarium [id].
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
  Future<AquariumParameters> getCurrentParameters({
    required int id,
    bool useMock = false,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.parameters(id),
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
      final manualParams = await _manualService.loadManualParameters(id);
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

      if (_autoCheckAlerts) {
        await _checkAllParametersForAlerts(completeParameters, id);
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
        'Unexpected error while fetching parameters',
        details: e.toString(),
        originalError: e,
      );
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
      AppLogger.e('Errore recupero storico per grafico', error: e);
      return [];
    } catch (e) {
      AppLogger.e('Errore imprevisto in getParameterHistoryForChart', error: e);
      return [];
    }
  }

  /// Returns hardcoded typical marine reef parameter values used as a mock
  /// fallback when the network is unavailable.
  AquariumParameters _getMockParameters() {
    return AquariumParameters(
      temperature: 25.0,
      ph: 8.20,
      salinity: 35.0,
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
  Future<void> _checkAllParametersForAlerts(
    AquariumParameters params,
    int aquariumId,
  ) async {
    final settings = await _notificationService.loadSettings(aquariumId);
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
}

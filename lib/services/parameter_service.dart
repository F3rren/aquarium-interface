import 'dart:async';
import 'package:acquariumfe/models/aquarium_parameters.dart';
import 'package:acquariumfe/services/api_service.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/services/manual_parameters_service.dart';
import 'package:acquariumfe/services/notification_settings_service.dart';
import 'package:acquariumfe/services/maintenance_task_service.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';
import 'package:acquariumfe/utils/exceptions.dart';
import 'package:acquariumfe/utils/retry_policy.dart';
import 'package:logger/logger.dart';

/// Service per gestire i parametri dell'acquario tramite API
class ParameterService {
  // Singleton pattern
  static final ParameterService _instance = ParameterService._internal();
  factory ParameterService() => _instance;
  ParameterService._internal();

  final ApiService _apiService = ApiService();
  final AlertManager _alertManager = AlertManager();
  final Logger _logger = Logger();
  final ManualParametersService _manualService = ManualParametersService();
  final NotificationSettingsService _notificationService =
      NotificationSettingsService();
  final MaintenanceTaskService _maintenanceService = MaintenanceTaskService();
  final TargetParametersService _targetService = TargetParametersService();

  // ID della vasca attualmente selezionata
  int? _currentid;

  // Cache per i parametri correnti
  AquariumParameters? _cachedParameters;
  DateTime? _lastFetch;

  // Timer per auto-refresh
  Timer? _refreshTimer;
  bool _isAutoRefreshEnabled = false;

  // Stream per notificare aggiornamenti
  final _parametersController =
      StreamController<AquariumParameters>.broadcast();
  Stream<AquariumParameters> get parametersStream =>
      _parametersController.stream;

  // Flag per abilitare/disabilitare controllo automatico alert
  bool _autoCheckAlerts = true;

  /// Ottieni lo stato corrente del controllo automatico alert
  bool get autoCheckAlertsEnabled => _autoCheckAlerts;

  /// Abilita o disabilita il controllo automatico degli alert
  void setAutoCheckAlerts(bool enabled) {
    _autoCheckAlerts = enabled;
  }

  /// Invalida la cache forzando il prossimo fetch dal server
  void invalidateCache() {
    _cachedParameters = null;
    _lastFetch = null;
  }

  /// Imposta la vasca corrente per cui recuperare i parametri
  void setCurrentAquarium(int id) {
    if (_currentid != id) {
      _currentid = id;
      // Invalida la cache quando cambia la vasca
      _cachedParameters = null;
      _lastFetch = null;

      // Imposta anche nei servizi dipendenti
      _manualService.setCurrentAquarium(id);
      _notificationService.setCurrentAquarium(id);
      _maintenanceService.setCurrentAquarium(id);
      _targetService.setCurrentAquarium(id);
    }
  }

  /// Ottieni i parametri correnti per la vasca specificata (o quella corrente)
  /// Se useMock=true, fallback a dati mockati in caso di errore
  Future<AquariumParameters> getCurrentParameters({
    int? id,
    bool useMock = true,
  }) async {
    final targetid = id ?? _currentid;

    if (targetid == null) {
      throw NoAquariumSelectedException(
        details:
            'Usa setCurrentAquarium() per selezionare una vasca prima di recuperare i parametri',
      );
    }

    try {
      // Endpoint per vasca specifica: /api/aquariums/{id}/parameters
      final response = await _apiService.get(
        '/aquariums/$targetid/parameters',
        retry: RetryPolicies.critical, // Dati critici, retry automatico
      );

      // Gestisci il caso in cui la risposta abbia un wrapper "data"
      final Map<String, dynamic> parametersData;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final data = response['data'];
          if (data is List && data.isNotEmpty) {
            // Se data è un array, prendi il primo elemento
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

      // Carica parametri manuali e uniscili
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

      // Controlla automaticamente gli alert se abilitato
      if (_autoCheckAlerts) {
        await _checkAllParametersForAlerts(completeParameters);
      }

      return completeParameters;
    } on AppException {
      // Rilancia le nostre eccezioni custom senza modificarle
      if (useMock) {
        return _getMockParameters();
      }
      rethrow;
    } catch (e) {
      // Errori imprevisti
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

  /// Ottieni parametri da cache (se disponibili e recenti)
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

  /// Ottieni storico parametri per la vasca specificata (o quella corrente)
  Future<List<AquariumParameters>> getParameterHistory({
    String? id,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    final targetid = id ?? _currentid;

    if (targetid == null) {
      return []; // Ritorna lista vuota invece di errore
    }

    try {
      // Costruisci query parameters
      final queryParams = <String, String>{};
      if (from != null) queryParams['from'] = from.toIso8601String();
      if (to != null) queryParams['to'] = to.toIso8601String();
      if (limit != null) queryParams['limit'] = limit.toString();

      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      // Endpoint per storico vasca specifica: /api/aquariums/{id}/parameters/history
      final endpoint =
          '/aquariums/$targetid/parameters/history${query.isNotEmpty ? '?$query' : ''}';

      final response = await _apiService.get(endpoint);

      // Gestisci il nuovo formato con id e measurements
      List<dynamic> historyJson;
      if (response is Map<String, dynamic>) {
        // Risposta con wrapper object {"data": {"id": 1, "measurements": [...]}}
        if (response.containsKey('data')) {
          var dataValue = response['data'];

          if (dataValue is Map<String, dynamic>) {
            // dataValue è l'oggetto con id e measurements
            if (dataValue['id'].toString() == targetid &&
                dataValue['measurements'] != null) {
              historyJson = dataValue['measurements'] as List<dynamic>;
            } else {
              historyJson = [];
            }
          } else if (dataValue is List) {
            // Formato vecchio con array di oggetti
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
        // Risposta diretta come array di oggetti con id e measurements
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

      final parameters = historyJson
          .map(
            (json) => AquariumParameters.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return parameters;
    } on AppException catch (e) {
      // Log dell'errore per debug (in produzione potresti usare un logger)
      _logger.e('Errore recupero storico parametri', error: e);
      return [];
    } catch (e) {
      _logger.e('Errore imprevisto in getParametersHistory', error: e);
      return [];
    }
  }

  /// Ottiene lo storico di un singolo parametro per i grafici
  /// param può essere: 'temperature', 'ph', 'salinity', 'orp', 'calcium', 'magnesium', 'kh', 'nitrate', 'phosphate'
  Future<List<Map<String, dynamic>>> getParameterHistoryForChart({
    required int aquariumId,
    required String parameterName,
    required Duration hours,
  }) async {
    final now = DateTime.now();

    // Calcola il range basandosi sui giorni invece che sulle ore precise
    final DateTime from;
    final DateTime to = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ); // Fine di oggi

    if (hours.inHours == 24) {
      // Ultime 24 ore: da inizio di ieri a fine di oggi
      from = DateTime(now.year, now.month, now.day - 1, 0, 0, 0);
    } else if (hours.inHours == 168) {
      // Ultimi 7 giorni: da 7 giorni fa a fine di oggi
      from = DateTime(now.year, now.month, now.day - 7, 0, 0, 0);
    } else if (hours.inHours == 720) {
      // Ultimi 30 giorni: da 30 giorni fa a fine di oggi
      from = DateTime(now.year, now.month, now.day - 30, 0, 0, 0);
    } else {
      // Fallback: usa sottrazione diretta
      from = now.subtract(hours);
    }

    try {
      // Costruisci query parameters
      final queryParams = <String, String>{
        'param': parameterName,
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      };

      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      final endpoint = '/aquariums/$aquariumId/parameters/history?$query';
      final response = await _apiService.get(endpoint);

      // Estrai i dati dalla risposta
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];
        if (data is List) {
          // Il backend ritorna già {timestamp, value} nel formato corretto!
          final result = data.map<Map<String, dynamic>>((item) {
            return {
              'timestamp':
                  item['timestamp'] ??
                  item['measuredAt'] ??
                  DateTime.now().toIso8601String(),
              'value': (item['value'] ?? item[parameterName] ?? 0).toDouble(),
            };
          }).toList();

          return result;
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

  /// Invia nuovi parametri al server
  Future<void> updateParameters(AquariumParameters parameters) async {
    await _apiService.post('/parameters', parameters.toJson());

    _cachedParameters = parameters;
    _parametersController.add(parameters);
  }

  /// Avvia auto-refresh dei parametri
  void startAutoRefresh({Duration interval = const Duration(seconds: 10)}) {
    if (_isAutoRefreshEnabled) return;

    _isAutoRefreshEnabled = true;

    // Primo caricamento immediato
    getCurrentParameters();

    // Poi carica periodicamente
    _refreshTimer = Timer.periodic(interval, (timer) {
      getCurrentParameters();
    });
  }

  /// Ferma auto-refresh
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _isAutoRefreshEnabled = false;
  }

  bool get isAutoRefreshEnabled => _isAutoRefreshEnabled;

  /// Dati mockati come fallback
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

  /// Controlla tutti i parametri e invia alert se necessario
  Future<void> _checkAllParametersForAlerts(AquariumParameters params) async {
    final settings = await _notificationService.loadSettings();

    // Temperatura (sempre disponibile da sensori)
    await _alertManager.checkParameter(
      name: 'Temperatura',
      value: params.temperature,
      unit: ' °C',
      thresholds: settings.temperature,
    );

    // pH (sempre disponibile da sensori)
    await _alertManager.checkParameter(
      name: 'pH',
      value: params.ph,
      unit: '',
      thresholds: settings.ph,
    );

    // Salinità (sempre disponibile da sensori)
    await _alertManager.checkParameter(
      name: 'Salinità',
      value: params.salinity,
      unit: '',
      thresholds: settings.salinity,
    );

    // ORP (sempre disponibile da sensori)
    await _alertManager.checkParameter(
      name: 'ORP',
      value: params.orp,
      unit: ' mV',
      thresholds: settings.orp,
    );

    // Parametri manuali (solo se disponibili)
    if (params.calcium != null) {
      await _alertManager.checkParameter(
        name: 'Calcio',
        value: params.calcium!,
        unit: ' mg/L',
        thresholds: settings.calcium,
      );
    }

    if (params.magnesium != null) {
      await _alertManager.checkParameter(
        name: 'Magnesio',
        value: params.magnesium!,
        unit: ' mg/L',
        thresholds: settings.magnesium,
      );
    }

    if (params.kh != null) {
      await _alertManager.checkParameter(
        name: 'KH',
        value: params.kh!,
        unit: ' dKH',
        thresholds: settings.kh,
      );
    }

    if (params.nitrate != null) {
      await _alertManager.checkParameter(
        name: 'Nitrati',
        value: params.nitrate!,
        unit: ' ppm',
        thresholds: settings.nitrate,
      );
    }

    if (params.phosphate != null) {
      await _alertManager.checkParameter(
        name: 'Fosfati',
        value: params.phosphate!,
        unit: ' ppm',
        thresholds: settings.phosphate,
      );
    }
  }

  /// Pulisci risorse
  void dispose() {
    stopAutoRefresh();
    _parametersController.close();
  }
}

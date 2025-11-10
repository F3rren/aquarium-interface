import 'dart:async';
import 'package:acquariumfe/models/aquarium_parameters.dart';
import 'package:acquariumfe/models/notification_settings.dart';
import 'package:acquariumfe/services/api_service.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/services/manual_parameters_service.dart';

/// Service per gestire i parametri dell'acquario tramite API
class ParameterService {
  // Singleton pattern
  static final ParameterService _instance = ParameterService._internal();
  factory ParameterService() => _instance;
  ParameterService._internal();

  final ApiService _apiService = ApiService();
  final AlertManager _alertManager = AlertManager();
  final ManualParametersService _manualService = ManualParametersService();
  
  // Cache per i parametri correnti
  AquariumParameters? _cachedParameters;
  DateTime? _lastFetch;
  
  // Timer per auto-refresh
  Timer? _refreshTimer;
  bool _isAutoRefreshEnabled = false;
  
  // Stream per notificare aggiornamenti
  final _parametersController = StreamController<AquariumParameters>.broadcast();
  Stream<AquariumParameters> get parametersStream => _parametersController.stream;

  // Flag per abilitare/disabilitare controllo automatico alert
  bool _autoCheckAlerts = true;
  
  /// Abilita o disabilita il controllo automatico degli alert
  void setAutoCheckAlerts(bool enabled) {
    _autoCheckAlerts = enabled;
  }

  /// Ottieni i parametri correnti
  /// Se useMock=true, fallback a dati mockati in caso di errore
  Future<AquariumParameters> getCurrentParameters({bool useMock = true}) async {
    try {
      final response = await _apiService.get('/parameters/current');
      final parameters = AquariumParameters.fromJson(response);
      
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
    } catch (e) {
      if (useMock) {
        return _getMockParameters();
      } else {
        rethrow;
      }
    }
  }

  /// Ottieni parametri da cache (se disponibili e recenti)
  AquariumParameters? getCachedParameters({Duration maxAge = const Duration(minutes: 5)}) {
    if (_cachedParameters == null || _lastFetch == null) {
      return null;
    }
    
    final age = DateTime.now().difference(_lastFetch!);
    if (age > maxAge) {
      return null;
    }
    
    return _cachedParameters;
  }

  /// Ottieni storico parametri
  Future<List<AquariumParameters>> getParameterHistory({
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    try {
      // Costruisci query parameters
      final queryParams = <String, String>{};
      if (from != null) queryParams['from'] = from.toIso8601String();
      if (to != null) queryParams['to'] = to.toIso8601String();
      if (limit != null) queryParams['limit'] = limit.toString();
      
      final query = queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      final endpoint = '/parameters/history${query.isNotEmpty ? '?$query' : ''}';
      
      final response = await _apiService.get(endpoint);
      
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => AquariumParameters.fromJson(json)).toList();
      
    } catch (e) {
      return [];
    }
  }

  /// Invia nuovi parametri al server
  Future<void> updateParameters(AquariumParameters parameters) async {
    try {
      await _apiService.post('/parameters', parameters.toJson());
      
      _cachedParameters = parameters;
      _parametersController.add(parameters);
      
    } catch (e) {
      rethrow;
    }
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
    final settings = NotificationSettings(); // Usa impostazioni di default
    
    // Temperatura (sempre disponibile da sensori)
    await _alertManager.checkParameter(
      name: 'Temperatura',
      value: params.temperature,
      unit: '°C',
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

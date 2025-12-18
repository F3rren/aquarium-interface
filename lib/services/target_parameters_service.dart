import 'api_service.dart';

/// Servizio per gestire i valori target desiderati dei parametri
class TargetParametersService {
  static final TargetParametersService _instance =
      TargetParametersService._internal();
  factory TargetParametersService() => _instance;
  TargetParametersService._internal();

  final ApiService _apiService = ApiService();
  int? _currentAquariumId;
  Map<String, double>? _cachedTargets;

  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
    _cachedTargets = null; // Invalida cache
  }

  // Valori di default
  static const double defaultTemperature = 25.0;
  static const double defaultPh = 8.2;
  static const double defaultSalinity = 1024.0;
  static const double defaultOrp = 360.0;

  Map<String, double> _getDefaults() {
    return {
      'temperature': defaultTemperature,
      'ph': defaultPh,
      'salinity': defaultSalinity,
      'orp': defaultOrp,
    };
  }

  /// Carica tutti i target dal backend
  Future<Map<String, double>> loadAllTargets() async {
    if (_currentAquariumId == null) {
      return _getDefaults();
    }

    if (_cachedTargets != null) {
      return _cachedTargets!;
    }

    try {
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/settings/targets',
      );

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'] as Map<String, dynamic>;
        _cachedTargets = {
          'temperature': (data['temperature'] ?? defaultTemperature).toDouble(),
          'ph': (data['ph'] ?? defaultPh).toDouble(),
          'salinity': (data['salinity'] ?? defaultSalinity).toDouble(),
          'orp': (data['orp'] ?? defaultOrp).toDouble(),
        };
        return _cachedTargets!;
      }

      return _getDefaults();
    } catch (e) {
      return _getDefaults();
    }
  }

  /// Salva un target specifico sul backend
  Future<void> saveTarget(String parameter, double value) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      // Carica tutti i target correnti
      final allTargets = await loadAllTargets();

      // Aggiorna il parametro specifico
      allTargets[parameter.toLowerCase()] = value;

      // Salva tutto sul backend
      await _apiService.post(
        '/aquariums/$_currentAquariumId/settings/targets',
        allTargets,
      );

      // Aggiorna cache
      _cachedTargets = allTargets;
    } catch (e) {
      rethrow;
    }
  }

  /// Ottieni target temperatura
  Future<double> getTargetTemperature() async {
    final targets = await loadAllTargets();
    return targets['temperature'] ?? defaultTemperature;
  }

  /// Ottieni target pH
  Future<double> getTargetPh() async {
    final targets = await loadAllTargets();
    return targets['ph'] ?? defaultPh;
  }

  /// Ottieni target salinità
  Future<double> getTargetSalinity() async {
    final targets = await loadAllTargets();
    return targets['salinity'] ?? defaultSalinity;
  }

  /// Ottieni target ORP
  Future<double> getTargetOrp() async {
    final targets = await loadAllTargets();
    return targets['orp'] ?? defaultOrp;
  }

  /// Reset ai valori di default
  Future<void> resetToDefaults() async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    await _apiService.post(
      '/aquariums/$_currentAquariumId/settings/targets',
      _getDefaults(),
    );

    _cachedTargets = _getDefaults();
  }
}

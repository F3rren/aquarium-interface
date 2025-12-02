import 'package:acquariumfe/services/api_service.dart';

/// Service per gestire i parametri manuali tramite API
class ManualParametersService {
  static final ManualParametersService _instance = ManualParametersService._internal();
  factory ManualParametersService() => _instance;
  ManualParametersService._internal();

  final ApiService _apiService = ApiService();
  
  int? _currentAquariumId;
  
  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
  }
  
  /// Salva parametri manuali sul backend
  Future<void> saveManualParameters({
    double? calcium,
    double? magnesium,
    double? kh,
    double? nitrate,
    double? phosphate,
  }) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }
    
    try {
      final body = <String, dynamic>{
        if (calcium != null) 'calcium': calcium,
        if (magnesium != null) 'magnesium': magnesium,
        if (kh != null) 'kh': kh,
        if (nitrate != null) 'nitrate': nitrate,
        if (phosphate != null) 'phosphate': phosphate,
        'measuredAt': DateTime.now().toIso8601String(),
      };
      
      await _apiService.post('/aquariums/$_currentAquariumId/parameters/manual', body);
    } catch (e) {
      rethrow;
    }
  }

  /// Carica parametri manuali dal backend
  Future<Map<String, double>> loadManualParameters() async {
    if (_currentAquariumId == null) {
      return _getDefaultValues();
    }
    
    try {
      final response = await _apiService.get('/aquariums/$_currentAquariumId/parameters/manual');
      
      final Map<String, dynamic> data;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final dataValue = response['data'];
          if (dataValue is Map<String, dynamic>) {
            data = dataValue;
          } else {
            return _getDefaultValues();
          }
        } else {
          data = response;
        }
      } else {
        return _getDefaultValues();
      }
      
      return {
        'calcium': (data['calcium'] ?? 420.0).toDouble(),
        'magnesium': (data['magnesium'] ?? 1280.0).toDouble(),
        'kh': (data['kh'] ?? 9.0).toDouble(),
        'nitrate': (data['nitrate'] ?? 5.0).toDouble(),
        'phosphate': (data['phosphate'] ?? 0.03).toDouble(),
      };
      
    } catch (e) {
      return _getDefaultValues();
    }
  }

  /// Ottieni singolo parametro
  Future<double> getParameter(String key) async {
    final params = await loadManualParameters();
    return params[key] ?? 0.0;
  }

  /// Aggiorna singolo parametro
  Future<void> updateParameter(String key, double value) async {
    final current = await loadManualParameters();
    
    await saveManualParameters(
      calcium: key == 'calcium' ? value : current['calcium'],
      magnesium: key == 'magnesium' ? value : current['magnesium'],
      kh: key == 'kh' ? value : current['kh'],
      nitrate: key == 'nitrate' ? value : current['nitrate'],
      phosphate: key == 'phosphate' ? value : current['phosphate'],
    );
  }

  /// Ottieni data ultimo aggiornamento
  Future<DateTime?> getLastUpdate() async {
    if (_currentAquariumId == null) return null;
    
    try {
      final response = await _apiService.get('/aquariums/$_currentAquariumId/parameters/manual');
      
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];
        if (data is Map<String, dynamic> && data.containsKey('measuredAt')) {
          return DateTime.parse(data['measuredAt']);
        }
      }
    } catch (e) {
      // Ignora errori
    }
    
    return null;
  }

  Map<String, double> _getDefaultValues() {
    return {
      'calcium': 420.0,
      'magnesium': 1280.0,
      'kh': 9.0,
      'nitrate': 5.0,
      'phosphate': 0.03,
    };
  }

  /// Resetta tutti i parametri ai valori di default
  Future<void> resetToDefaults() async {
    if (_currentAquariumId == null) return;
    
    try {
      await _apiService.delete('/aquariums/$_currentAquariumId/parameters/manual');
    } catch (e) {
      rethrow;
    }
  }
}
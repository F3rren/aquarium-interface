import 'package:shared_preferences/shared_preferences.dart';

/// Service per gestire i parametri manuali salvati localmente
class ManualParametersService {
  static final ManualParametersService _instance = ManualParametersService._internal();
  factory ManualParametersService() => _instance;
  ManualParametersService._internal();

  static const String _calciumKey = 'manual_calcium';
  static const String _magnesiumKey = 'manual_magnesium';
  static const String _khKey = 'manual_kh';
  static const String _nitrateKey = 'manual_nitrate';
  static const String _phosphateKey = 'manual_phosphate';
  static const String _lastUpdateKey = 'manual_last_update';

  /// Salva parametri manuali
  Future<void> saveManualParameters({
    double? calcium,
    double? magnesium,
    double? kh,
    double? nitrate,
    double? phosphate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (calcium != null) await prefs.setDouble(_calciumKey, calcium);
    if (magnesium != null) await prefs.setDouble(_magnesiumKey, magnesium);
    if (kh != null) await prefs.setDouble(_khKey, kh);
    if (nitrate != null) await prefs.setDouble(_nitrateKey, nitrate);
    if (phosphate != null) await prefs.setDouble(_phosphateKey, phosphate);
    
    // Salva timestamp ultimo aggiornamento
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// Carica parametri manuali
  Future<Map<String, double>> loadManualParameters() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'calcium': prefs.getDouble(_calciumKey) ?? 420.0,
      'magnesium': prefs.getDouble(_magnesiumKey) ?? 1280.0,
      'kh': prefs.getDouble(_khKey) ?? 9.0,
      'nitrate': prefs.getDouble(_nitrateKey) ?? 5.0,
      'phosphate': prefs.getDouble(_phosphateKey) ?? 0.03,
    };
  }

  /// Ottieni singolo parametro
  Future<double> getParameter(String key) async {
    final prefs = await SharedPreferences.getInstance();
    
    switch (key) {
      case 'calcium':
        return prefs.getDouble(_calciumKey) ?? 420.0;
      case 'magnesium':
        return prefs.getDouble(_magnesiumKey) ?? 1280.0;
      case 'kh':
        return prefs.getDouble(_khKey) ?? 9.0;
      case 'nitrate':
        return prefs.getDouble(_nitrateKey) ?? 5.0;
      case 'phosphate':
        return prefs.getDouble(_phosphateKey) ?? 0.03;
      default:
        return 0.0;
    }
  }

  /// Aggiorna singolo parametro
  Future<void> updateParameter(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    
    switch (key) {
      case 'calcium':
        await prefs.setDouble(_calciumKey, value);
        break;
      case 'magnesium':
        await prefs.setDouble(_magnesiumKey, value);
        break;
      case 'kh':
        await prefs.setDouble(_khKey, value);
        break;
      case 'nitrate':
        await prefs.setDouble(_nitrateKey, value);
        break;
      case 'phosphate':
        await prefs.setDouble(_phosphateKey, value);
        break;
    }
    
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// Ottieni data ultimo aggiornamento
  Future<DateTime?> getLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastUpdateKey);
    
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  /// Resetta tutti i parametri ai valori di default
  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setDouble(_calciumKey, 420.0);
    await prefs.setDouble(_magnesiumKey, 1280.0);
    await prefs.setDouble(_khKey, 9.0);
    await prefs.setDouble(_nitrateKey, 5.0);
    await prefs.setDouble(_phosphateKey, 0.03);
    await prefs.remove(_lastUpdateKey);
  }
}

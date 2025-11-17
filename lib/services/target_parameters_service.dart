import 'package:shared_preferences/shared_preferences.dart';

/// Servizio per gestire i valori target desiderati dei parametri
class TargetParametersService {
  static final TargetParametersService _instance = TargetParametersService._internal();
  factory TargetParametersService() => _instance;
  TargetParametersService._internal();

  // Chiavi per SharedPreferences
  static const String _keyTargetTemperature = 'target_temperature';
  static const String _keyTargetPh = 'target_ph';
  static const String _keyTargetSalinity = 'target_salinity';
  static const String _keyTargetOrp = 'target_orp';

  // Valori di default
  static const double defaultTemperature = 25.0;
  static const double defaultPh = 8.2;
  static const double defaultSalinity = 1024.0;
  static const double defaultOrp = 360.0;

  /// Carica tutti i target
  Future<Map<String, double>> loadAllTargets() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'temperature': prefs.getDouble(_keyTargetTemperature) ?? defaultTemperature,
      'ph': prefs.getDouble(_keyTargetPh) ?? defaultPh,
      'salinity': prefs.getDouble(_keyTargetSalinity) ?? defaultSalinity,
      'orp': prefs.getDouble(_keyTargetOrp) ?? defaultOrp,
    };
  }

  /// Salva un target specifico
  Future<void> saveTarget(String parameter, double value) async {
    final prefs = await SharedPreferences.getInstance();
    
    switch (parameter.toLowerCase()) {
      case 'temperature':
        await prefs.setDouble(_keyTargetTemperature, value);
        break;
      case 'ph':
        await prefs.setDouble(_keyTargetPh, value);
        break;
      case 'salinity':
        await prefs.setDouble(_keyTargetSalinity, value);
        break;
      case 'orp':
        await prefs.setDouble(_keyTargetOrp, value);
        break;
    }
  }

  /// Ottieni target temperatura
  Future<double> getTargetTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyTargetTemperature) ?? defaultTemperature;
  }

  /// Ottieni target pH
  Future<double> getTargetPh() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyTargetPh) ?? defaultPh;
  }

  /// Ottieni target salinità
  Future<double> getTargetSalinity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyTargetSalinity) ?? defaultSalinity;
  }

  /// Ottieni target ORP
  Future<double> getTargetOrp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyTargetOrp) ?? defaultOrp;
  }

  /// Reset ai valori di default
  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTargetTemperature, defaultTemperature);
    await prefs.setDouble(_keyTargetPh, defaultPh);
    await prefs.setDouble(_keyTargetSalinity, defaultSalinity);
    await prefs.setDouble(_keyTargetOrp, defaultOrp);
  }
}

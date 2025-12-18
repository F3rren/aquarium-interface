import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification_settings.dart';

/// Servizio singleton per gestire la persistenza delle impostazioni notifiche
class NotificationPreferencesService {
  static final NotificationPreferencesService _instance =
      NotificationPreferencesService._internal();
  factory NotificationPreferencesService() => _instance;
  NotificationPreferencesService._internal();

  static const String _keySettings = 'notification_settings';

  /// Carica le impostazioni salvate o restituisce quelle di default
  Future<NotificationSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keySettings);

      if (jsonString != null && jsonString.isNotEmpty) {
        // Carica impostazioni salvate
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final settings = NotificationSettings.fromJson(jsonMap);
        return settings;
      }
    } catch (e) {
      // In caso di errore, restituisci impostazioni di default
      return NotificationSettings();
    }

    // Restituisce impostazioni di default se non trovate
    return NotificationSettings();
  }

  /// Salva le impostazioni correnti
  Future<bool> saveSettings(NotificationSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonMap = settings.toJson();
      final jsonString = jsonEncode(jsonMap);
      final success = await prefs.setString(_keySettings, jsonString);

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Resetta le impostazioni ai valori di default
  Future<bool> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_keySettings);

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Verifica se esistono impostazioni salvate
  Future<bool> hasCustomSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_keySettings);
    } catch (e) {
      return false;
    }
  }

  /// Salva una singola soglia parametro (helper per aggiornamenti rapidi)
  Future<bool> updateParameterThreshold(
    NotificationSettings currentSettings,
    String parameterName,
    ParameterThresholds newThreshold,
  ) async {
    NotificationSettings updatedSettings;

    switch (parameterName) {
      case 'Temperatura':
        updatedSettings = currentSettings.copyWith(temperature: newThreshold);
        break;
      case 'pH':
        updatedSettings = currentSettings.copyWith(ph: newThreshold);
        break;
      case 'Salinità':
        updatedSettings = currentSettings.copyWith(salinity: newThreshold);
        break;
      case 'ORP':
        updatedSettings = currentSettings.copyWith(orp: newThreshold);
        break;
      case 'Calcio':
        updatedSettings = currentSettings.copyWith(calcium: newThreshold);
        break;
      case 'Magnesio':
        updatedSettings = currentSettings.copyWith(magnesium: newThreshold);
        break;
      case 'KH':
        updatedSettings = currentSettings.copyWith(kh: newThreshold);
        break;
      case 'Nitrati':
        updatedSettings = currentSettings.copyWith(nitrate: newThreshold);
        break;
      case 'Fosfati':
        updatedSettings = currentSettings.copyWith(phosphate: newThreshold);
        break;
      default:
        return false;
    }

    return await saveSettings(updatedSettings);
  }

  /// Ottiene statistiche sull'utilizzo delle notifiche
  Future<Map<String, dynamic>> getStats() async {
    try {
      final settings = await loadSettings();
      final hasCustom = await hasCustomSettings();

      int enabledParameters = 0;
      if (settings.temperature.enabled) enabledParameters++;
      if (settings.ph.enabled) enabledParameters++;
      if (settings.salinity.enabled) enabledParameters++;
      if (settings.orp.enabled) enabledParameters++;
      if (settings.calcium.enabled) enabledParameters++;
      if (settings.magnesium.enabled) enabledParameters++;
      if (settings.kh.enabled) enabledParameters++;
      if (settings.nitrate.enabled) enabledParameters++;
      if (settings.phosphate.enabled) enabledParameters++;

      int enabledReminders = 0;
      if (settings.maintenanceReminders.waterChange.enabled) enabledReminders++;
      if (settings.maintenanceReminders.filterCleaning.enabled)
        enabledReminders++;
      if (settings.maintenanceReminders.parameterTesting.enabled)
        enabledReminders++;
      if (settings.maintenanceReminders.lightMaintenance.enabled)
        enabledReminders++;

      return {
        'hasCustomSettings': hasCustom,
        'enabledAlerts': settings.enabledAlerts,
        'enabledMaintenance': settings.enabledMaintenance,
        'enabledDaily': settings.enabledDaily,
        'parametersMonitored': enabledParameters,
        'remindersActive': enabledReminders,
        'totalParameters': 9,
        'totalReminders': 4,
      };
    } catch (e) {
      return {
        'hasCustomSettings': false,
        'enabledAlerts': false,
        'enabledMaintenance': false,
        'enabledDaily': false,
        'parametersMonitored': 0,
        'remindersActive': 0,
        'totalParameters': 9,
        'totalReminders': 4,
      };
    }
  }
}

/// Service that persists notification settings to local device storage.
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification_settings.dart';

/// Singleton that reads and writes [NotificationSettings] to
/// [SharedPreferences] under the key `'notification_settings'`.
///
/// This is the **local** persistence layer — it stores the user's alert and
/// reminder configuration on the device without a network round-trip.
/// [NotificationSettingsService] is its backend-synced counterpart.
///
/// All methods silently handle errors: [loadSettings] and [getStats] return
/// safe defaults, [saveSettings] and [resetToDefaults] return a boolean
/// success flag rather than throwing.
class NotificationPreferencesService {
  static final NotificationPreferencesService _instance =
      NotificationPreferencesService._internal();
  factory NotificationPreferencesService() => _instance;
  NotificationPreferencesService._internal();

  /// SharedPreferences key under which [NotificationSettings] JSON is stored.
  static const String _keySettings = 'notification_settings';

  /// Loads and deserialises the stored [NotificationSettings].
  ///
  /// Returns a new [NotificationSettings] with default values when:
  /// - no settings have been saved yet
  /// - the stored JSON is empty or cannot be parsed
  Future<NotificationSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keySettings);

      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return NotificationSettings.fromJson(jsonMap);
      }
    } catch (e) {
      return NotificationSettings();
    }

    return NotificationSettings();
  }

  /// Serialises [settings] to JSON and stores it under [_keySettings].
  ///
  /// Returns `true` on success, `false` on any error.
  Future<bool> saveSettings(NotificationSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      return await prefs.setString(_keySettings, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Removes the stored settings key, causing the next [loadSettings] call to
  /// return defaults.
  ///
  /// Returns `true` on success, `false` on any error.
  Future<bool> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_keySettings);
    } catch (e) {
      return false;
    }
  }

  /// Returns `true` if custom notification settings have been saved, `false`
  /// if the user is still on defaults.
  Future<bool> hasCustomSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_keySettings);
    } catch (e) {
      return false;
    }
  }

  /// Helper that patches a single parameter threshold within [currentSettings]
  /// and saves the result.
  ///
  /// [parameterName] must be one of the Italian display names used in the UI:
  /// `'Temperatura'`, `'pH'`, `'Salinità'`, `'ORP'`, `'Calcio'`,
  /// `'Magnesio'`, `'KH'`, `'Nitrati'`, `'Fosfati'`.
  ///
  /// Returns `false` (without saving) when [parameterName] is unrecognised.
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

  /// Returns a summary map describing the current notification configuration.
  ///
  /// Keys returned:
  /// - `'hasCustomSettings'` (bool) — whether non-default settings are stored
  /// - `'enabledAlerts'` (bool)
  /// - `'enabledMaintenance'` (bool)
  /// - `'enabledDaily'` (bool)
  /// - `'parametersMonitored'` (int) — count of parameters with enabled thresholds (0–9)
  /// - `'remindersActive'` (int) — count of active maintenance reminders (0–4)
  /// - `'totalParameters'` (int) — always 9
  /// - `'totalReminders'` (int) — always 4
  ///
  /// Returns all-zero/false values on error.
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
      if (settings.maintenanceReminders.filterCleaning.enabled) {
        enabledReminders++;
      }
      if (settings.maintenanceReminders.parameterTesting.enabled) {
        enabledReminders++;
      }
      if (settings.maintenanceReminders.lightMaintenance.enabled) {
        enabledReminders++;
      }

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

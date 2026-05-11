/// Service that persists notification settings to the backend API.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/features/settings/domain/models/notification_settings.dart';
import 'package:acquariumfe/core/network/api_service.dart';

/// Singleton that reads and writes [NotificationSettings] for a specific
/// aquarium via the REST endpoint
/// `…/aquariums/{id}/settings/notifications`.
///
/// Settings are backed by an in-memory cache ([_cachedSettings]) to avoid
/// redundant network requests. The cache is invalidated whenever the active
/// aquarium changes ([setCurrentAquarium]) or when the settings are reset
/// ([resetToDefaults]).
///
/// Contrast with [NotificationPreferencesService], which stores settings
/// locally on the device via [SharedPreferences] without a network call.
class NotificationSettingsService {
  static final NotificationSettingsService _instance =
      NotificationSettingsService._internal();
  factory NotificationSettingsService() => _instance;
  NotificationSettingsService._internal();

  final ApiService _apiService = ApiService();

  /// ID of the currently active aquarium.
  int? _currentAquariumId;

  /// In-memory cache of the loaded settings; cleared on aquarium change.
  NotificationSettings? _cachedSettings;

  /// Sets the aquarium context and clears the settings cache so the next
  /// [loadSettings] call fetches fresh data from the backend.
  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
    _cachedSettings = null;
  }

  /// Persists [settings] to the backend and updates the in-memory cache.
  ///
  /// Throws if no aquarium has been selected. Propagates API exceptions so the
  /// caller can surface an error to the user.
  Future<void> saveSettings(NotificationSettings settings) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      await _apiService.post(
        ApiEndpoints.notificationSettings(_currentAquariumId!),
        settings.toJson(),
      );

      _cachedSettings = settings;
    } catch (e) {
      rethrow;
    }
  }

  /// Returns the [NotificationSettings] for the current aquarium.
  ///
  /// Serves from [_cachedSettings] on subsequent calls to avoid network round
  /// trips. Returns a default [NotificationSettings] when:
  /// - no aquarium is selected
  /// - the backend returns an unexpected response shape
  /// - any network or parse error occurs
  Future<NotificationSettings> loadSettings() async {
    if (_currentAquariumId == null) {
      return NotificationSettings();
    }

    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    try {
      final response = await _apiService.get(
        ApiEndpoints.notificationSettings(_currentAquariumId!),
      );

      final Map<String, dynamic> data;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final dataValue = response['data'];
          if (dataValue is Map<String, dynamic>) {
            data = dataValue;
          } else {
            return NotificationSettings();
          }
        } else {
          data = response;
        }
      } else {
        return NotificationSettings();
      }

      _cachedSettings = NotificationSettings.fromJson(data);
      return _cachedSettings!;
    } catch (e) {
      return NotificationSettings();
    }
  }

  /// Patches a single parameter threshold without modifying the rest of the
  /// settings.
  ///
  /// [parameterName] must be a backend camelCase key:
  /// `'temperature'`, `'ph'`, `'salinity'`, `'orp'`, `'calcium'`,
  /// `'magnesium'`, `'kh'`, `'nitrate'`, `'phosphate'`.
  /// Unrecognised keys are silently ignored (early return).
  Future<void> updateParameterThreshold({
    required String parameterName,
    required ParameterThresholds threshold,
  }) async {
    final current = await loadSettings();

    NotificationSettings updated;
    switch (parameterName) {
      case 'temperature':
        updated = current.copyWith(temperature: threshold);
        break;
      case 'ph':
        updated = current.copyWith(ph: threshold);
        break;
      case 'salinity':
        updated = current.copyWith(salinity: threshold);
        break;
      case 'orp':
        updated = current.copyWith(orp: threshold);
        break;
      case 'calcium':
        updated = current.copyWith(calcium: threshold);
        break;
      case 'magnesium':
        updated = current.copyWith(magnesium: threshold);
        break;
      case 'kh':
        updated = current.copyWith(kh: threshold);
        break;
      case 'nitrate':
        updated = current.copyWith(nitrate: threshold);
        break;
      case 'phosphate':
        updated = current.copyWith(phosphate: threshold);
        break;
      default:
        return;
    }

    await saveSettings(updated);
  }

  /// Enables or disables the master parameter-alert switch and saves the result.
  Future<void> setAlertsEnabled(bool enabled) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(enabledAlerts: enabled));
  }

  /// Enables or disables the master maintenance-reminder switch and saves.
  Future<void> setMaintenanceEnabled(bool enabled) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(enabledMaintenance: enabled));
  }

  /// Enables or disables the daily-summary notification switch and saves.
  Future<void> setDailyEnabled(bool enabled) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(enabledDaily: enabled));
  }

  /// Replaces all maintenance-reminder schedules with [reminders] and saves.
  Future<void> updateMaintenanceReminders(
    MaintenanceReminders reminders,
  ) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(maintenanceReminders: reminders));
  }

  /// Deletes the stored settings on the backend and clears the local cache.
  ///
  /// The next [loadSettings] call will return server-side defaults. Silently
  /// returns if no aquarium has been selected.
  Future<void> resetToDefaults() async {
    if (_currentAquariumId == null) return;

    try {
      await _apiService.delete(
        ApiEndpoints.notificationSettings(_currentAquariumId!),
      );
      _cachedSettings = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Manually invalidates the in-memory cache without making a network call.
  void clearCache() {
    _cachedSettings = null;
  }
}

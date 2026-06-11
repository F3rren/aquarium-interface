/// Service that persists notification settings to the backend API.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/features/settings/domain/models/notification_settings.dart';
import 'package:acquariumfe/core/network/api_service.dart';

/// Service that reads and writes [NotificationSettings] for a specific
/// aquarium via the REST endpoint
/// `…/aquariums/{id}/settings/notifications`.
///
/// The target aquarium is passed explicitly to every operation as
/// [aquariumId]; the service holds no mutable "current aquarium" state. Loaded
/// settings are cached per aquarium in [_cache] to avoid redundant network
/// requests.
///
/// Contrast with [NotificationPreferencesService], which stores settings
/// locally on the device via [SharedPreferences] without a network call.
class NotificationSettingsService {
  /// Creates a service backed by the shared [ApiService].
  ///
  /// Obtain the app-wide instance via Riverpod
  /// ([notificationSettingsServiceProvider]) rather than constructing directly.
  NotificationSettingsService(this._apiService);

  final ApiService _apiService;

  /// Per-aquarium in-memory cache of loaded settings.
  final Map<int, NotificationSettings> _cache = {};

  /// Persists [settings] for aquarium [aquariumId] and updates the cache.
  ///
  /// Propagates API exceptions so the caller can surface an error to the user.
  Future<void> saveSettings(int aquariumId, NotificationSettings settings) async {
    try {
      await _apiService.post(
        ApiEndpoints.notificationSettings(aquariumId),
        settings.toJson(),
      );

      _cache[aquariumId] = settings;
    } catch (e) {
      rethrow;
    }
  }

  /// Returns the [NotificationSettings] for aquarium [aquariumId].
  ///
  /// Serves from the per-aquarium cache on subsequent calls. Returns a default
  /// [NotificationSettings] when the backend returns an unexpected response
  /// shape or any network/parse error occurs.
  Future<NotificationSettings> loadSettings(int aquariumId) async {
    final cached = _cache[aquariumId];
    if (cached != null) {
      return cached;
    }

    try {
      final response = await _apiService.get(
        ApiEndpoints.notificationSettings(aquariumId),
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

      final settings = NotificationSettings.fromJson(data);
      _cache[aquariumId] = settings;
      return settings;
    } catch (e) {
      return NotificationSettings();
    }
  }

  /// Patches a single parameter threshold for aquarium [aquariumId] without
  /// modifying the rest of the settings.
  ///
  /// [parameterName] must be a backend camelCase key:
  /// `'temperature'`, `'ph'`, `'salinity'`, `'orp'`, `'calcium'`,
  /// `'magnesium'`, `'kh'`, `'nitrate'`, `'phosphate'`.
  /// Unrecognised keys are silently ignored (early return).
  Future<void> updateParameterThreshold(
    int aquariumId, {
    required String parameterName,
    required ParameterThresholds threshold,
  }) async {
    final current = await loadSettings(aquariumId);

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

    await saveSettings(aquariumId, updated);
  }

  /// Enables or disables the master parameter-alert switch and saves.
  Future<void> setAlertsEnabled(int aquariumId, bool enabled) async {
    final current = await loadSettings(aquariumId);
    await saveSettings(aquariumId, current.copyWith(enabledAlerts: enabled));
  }

  /// Enables or disables the master maintenance-reminder switch and saves.
  Future<void> setMaintenanceEnabled(int aquariumId, bool enabled) async {
    final current = await loadSettings(aquariumId);
    await saveSettings(
      aquariumId,
      current.copyWith(enabledMaintenance: enabled),
    );
  }

  /// Enables or disables the daily-summary notification switch and saves.
  Future<void> setDailyEnabled(int aquariumId, bool enabled) async {
    final current = await loadSettings(aquariumId);
    await saveSettings(aquariumId, current.copyWith(enabledDaily: enabled));
  }

  /// Replaces all maintenance-reminder schedules with [reminders] and saves.
  Future<void> updateMaintenanceReminders(
    int aquariumId,
    MaintenanceReminders reminders,
  ) async {
    final current = await loadSettings(aquariumId);
    await saveSettings(
      aquariumId,
      current.copyWith(maintenanceReminders: reminders),
    );
  }

  /// Deletes the stored settings for aquarium [aquariumId] and drops its cache
  /// entry. The next [loadSettings] call will return server-side defaults.
  Future<void> resetToDefaults(int aquariumId) async {
    try {
      await _apiService.delete(
        ApiEndpoints.notificationSettings(aquariumId),
      );
      _cache.remove(aquariumId);
    } catch (e) {
      rethrow;
    }
  }

  /// Manually invalidates the in-memory cache without making a network call.
  void clearCache() {
    _cache.clear();
  }
}

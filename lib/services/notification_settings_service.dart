import 'package:acquariumfe/models/notification_settings.dart';
import 'package:acquariumfe/services/api_service.dart';

/// Service per gestire le impostazioni notifiche tramite API
class NotificationSettingsService {
  static final NotificationSettingsService _instance =
      NotificationSettingsService._internal();
  factory NotificationSettingsService() => _instance;
  NotificationSettingsService._internal();

  final ApiService _apiService = ApiService();

  int? _currentAquariumId;
  NotificationSettings? _cachedSettings;

  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
    _cachedSettings = null;
  }

  /// Salva impostazioni notifiche sul backend
  Future<void> saveSettings(NotificationSettings settings) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      await _apiService.post(
        '/aquariums/$_currentAquariumId/settings/notifications',
        settings.toJson(),
      );

      _cachedSettings = settings;
    } catch (e) {
      rethrow;
    }
  }

  /// Carica impostazioni notifiche dal backend
  Future<NotificationSettings> loadSettings() async {
    if (_currentAquariumId == null) {
      return NotificationSettings();
    }

    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    try {
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/settings/notifications',
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

  /// Aggiorna singola soglia parametro
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

  /// Abilita/disabilita notifiche alert
  Future<void> setAlertsEnabled(bool enabled) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(enabledAlerts: enabled));
  }

  /// Abilita/disabilita notifiche manutenzione
  Future<void> setMaintenanceEnabled(bool enabled) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(enabledMaintenance: enabled));
  }

  /// Abilita/disabilita notifiche giornaliere
  Future<void> setDailyEnabled(bool enabled) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(enabledDaily: enabled));
  }

  /// Aggiorna promemoria manutenzione
  Future<void> updateMaintenanceReminders(
    MaintenanceReminders reminders,
  ) async {
    final current = await loadSettings();
    await saveSettings(current.copyWith(maintenanceReminders: reminders));
  }

  /// Resetta alle impostazioni di default
  Future<void> resetToDefaults() async {
    if (_currentAquariumId == null) return;

    try {
      await _apiService.delete(
        '/aquariums/$_currentAquariumId/settings/notifications',
      );
      _cachedSettings = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Cancella cache
  void clearCache() {
    _cachedSettings = null;
  }
}

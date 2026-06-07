/// User-configurable notification preferences and parameter alert thresholds.
library;

import 'package:acquariumfe/core/constants/parameter_thresholds.dart';

/// Top-level configuration for all app notifications.
///
/// Contains three global toggle switches and per-parameter threshold objects.
/// Default values reflect typical healthy ranges for a marine reef aquarium.
class NotificationSettings {
  /// Master switch for parameter out-of-range alert notifications.
  final bool enabledAlerts;

  /// Master switch for maintenance reminder notifications.
  final bool enabledMaintenance;

  /// Master switch for optional daily summary notifications (off by default).
  final bool enabledDaily;

  // ── Per-parameter thresholds ───────────────────────────────────────────────

  /// Alert thresholds for water temperature (°C). Defaults from
  /// [ParameterThresholdDefaults.temperature].
  final ParameterThresholds temperature;

  /// Alert thresholds for pH. Defaults from [ParameterThresholdDefaults.ph].
  final ParameterThresholds ph;

  /// Alert thresholds for salinity. **Legacy ×1000 scale** (e.g. 1024), unlike
  /// the sensor readings which are specific gravity (~1.024) — see the
  /// FIXME in the constructor.
  final ParameterThresholds salinity;

  /// Alert thresholds for ORP (mV). Default: 300–400 mV.
  final ParameterThresholds orp;

  /// Alert thresholds for dissolved calcium (mg/L). Default: 400–450 mg/L.
  final ParameterThresholds calcium;

  /// Alert thresholds for dissolved magnesium (mg/L). Default: 1250–1350 mg/L.
  final ParameterThresholds magnesium;

  /// Alert thresholds for carbonate hardness (dKH). Default: 7–9 dKH.
  final ParameterThresholds kh;

  /// Alert thresholds for nitrates (mg/L). Default: 0–10 mg/L.
  final ParameterThresholds nitrate;

  /// Alert thresholds for phosphates (mg/L). Default: 0–0.1 mg/L.
  final ParameterThresholds phosphate;

  /// Reminder schedules for the four built-in maintenance task types.
  final MaintenanceReminders maintenanceReminders;

  NotificationSettings({
    this.enabledAlerts = true,
    this.enabledMaintenance = true,
    this.enabledDaily = false,
    ParameterThresholds? temperature,
    ParameterThresholds? ph,
    ParameterThresholds? salinity,
    ParameterThresholds? orp,
    ParameterThresholds? calcium,
    ParameterThresholds? magnesium,
    ParameterThresholds? kh,
    ParameterThresholds? nitrate,
    ParameterThresholds? phosphate,
    MaintenanceReminders? maintenanceReminders,
  }) : temperature = temperature ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.temperature.min,
             max: ParameterThresholdDefaults.temperature.max,
           ),
       ph = ph ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.ph.min,
             max: ParameterThresholdDefaults.ph.max,
           ),
       // FIXME(salinity-scale): legacy ×1000 default. Sensor readings are
       // specific gravity (~1.024), so this 1020–1028 range never matches real
       // data and salinity alerts misfire. Switch to
       // ParameterThresholdDefaults.salinity once the backend target-salinity
       // scale is confirmed (the salinity gauge/targets also use ×1000).
       salinity = salinity ?? ParameterThresholds(min: 1020.0, max: 1028.0),
       orp = orp ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.orp.min,
             max: ParameterThresholdDefaults.orp.max,
           ),
       calcium = calcium ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.calcium.min,
             max: ParameterThresholdDefaults.calcium.max,
           ),
       magnesium = magnesium ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.magnesium.min,
             max: ParameterThresholdDefaults.magnesium.max,
           ),
       kh = kh ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.kh.min,
             max: ParameterThresholdDefaults.kh.max,
           ),
       nitrate = nitrate ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.nitrate.min,
             max: ParameterThresholdDefaults.nitrate.max,
           ),
       phosphate = phosphate ??
           ParameterThresholds(
             min: ParameterThresholdDefaults.phosphate.min,
             max: ParameterThresholdDefaults.phosphate.max,
           ),
       maintenanceReminders = maintenanceReminders ?? MaintenanceReminders();

  /// Returns a copy with the specified fields replaced.
  NotificationSettings copyWith({
    bool? enabledAlerts,
    bool? enabledMaintenance,
    bool? enabledDaily,
    ParameterThresholds? temperature,
    ParameterThresholds? ph,
    ParameterThresholds? salinity,
    ParameterThresholds? orp,
    ParameterThresholds? calcium,
    ParameterThresholds? magnesium,
    ParameterThresholds? kh,
    ParameterThresholds? nitrate,
    ParameterThresholds? phosphate,
    MaintenanceReminders? maintenanceReminders,
  }) {
    return NotificationSettings(
      enabledAlerts: enabledAlerts ?? this.enabledAlerts,
      enabledMaintenance: enabledMaintenance ?? this.enabledMaintenance,
      enabledDaily: enabledDaily ?? this.enabledDaily,
      temperature: temperature ?? this.temperature,
      ph: ph ?? this.ph,
      salinity: salinity ?? this.salinity,
      orp: orp ?? this.orp,
      calcium: calcium ?? this.calcium,
      magnesium: magnesium ?? this.magnesium,
      kh: kh ?? this.kh,
      nitrate: nitrate ?? this.nitrate,
      phosphate: phosphate ?? this.phosphate,
      maintenanceReminders: maintenanceReminders ?? this.maintenanceReminders,
    );
  }

  /// Serialises to JSON for persistence.
  Map<String, dynamic> toJson() {
    return {
      'enabledAlerts': enabledAlerts,
      'enabledMaintenance': enabledMaintenance,
      'enabledDaily': enabledDaily,
      'temperature': temperature.toJson(),
      'ph': ph.toJson(),
      'salinity': salinity.toJson(),
      'orp': orp.toJson(),
      'calcium': calcium.toJson(),
      'magnesium': magnesium.toJson(),
      'kh': kh.toJson(),
      'nitrate': nitrate.toJson(),
      'phosphate': phosphate.toJson(),
      'maintenanceReminders': maintenanceReminders.toJson(),
    };
  }

  /// Deserialises from a JSON map. Missing fields use constructor defaults.
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabledAlerts: json['enabledAlerts'] ?? true,
      enabledMaintenance: json['enabledMaintenance'] ?? true,
      enabledDaily: json['enabledDaily'] ?? false,
      temperature: json['temperature'] != null
          ? ParameterThresholds.fromJson(json['temperature'])
          : null,
      ph: json['ph'] != null ? ParameterThresholds.fromJson(json['ph']) : null,
      salinity: json['salinity'] != null
          ? ParameterThresholds.fromJson(json['salinity'])
          : null,
      orp: json['orp'] != null
          ? ParameterThresholds.fromJson(json['orp'])
          : null,
      calcium: json['calcium'] != null
          ? ParameterThresholds.fromJson(json['calcium'])
          : null,
      magnesium: json['magnesium'] != null
          ? ParameterThresholds.fromJson(json['magnesium'])
          : null,
      kh: json['kh'] != null ? ParameterThresholds.fromJson(json['kh']) : null,
      nitrate: json['nitrate'] != null
          ? ParameterThresholds.fromJson(json['nitrate'])
          : null,
      phosphate: json['phosphate'] != null
          ? ParameterThresholds.fromJson(json['phosphate'])
          : null,
      maintenanceReminders: json['maintenanceReminders'] != null
          ? MaintenanceReminders.fromJson(json['maintenanceReminders'])
          : null,
    );
  }
}

/// Minimum/maximum acceptable range for a single water parameter.
///
/// When [enabled] is `false` the threshold is inactive and [isOutOfRange]
/// always returns `false`.
class ParameterThresholds {
  /// Lower bound of the acceptable range (inclusive).
  final double min;

  /// Upper bound of the acceptable range (inclusive).
  final double max;

  /// Whether this threshold is currently active. Disabled thresholds never
  /// fire notifications.
  final bool enabled;

  ParameterThresholds({
    required this.min,
    required this.max,
    this.enabled = true,
  });

  /// Returns `true` when [value] falls outside [min]–[max] and [enabled] is
  /// `true`.
  bool isOutOfRange(double value) {
    return enabled && (value < min || value > max);
  }

  /// Returns a copy with the specified fields replaced.
  ParameterThresholds copyWith({double? min, double? max, bool? enabled}) {
    return ParameterThresholds(
      min: min ?? this.min,
      max: max ?? this.max,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {'min': min, 'max': max, 'enabled': enabled};
  }

  factory ParameterThresholds.fromJson(Map<String, dynamic> json) {
    return ParameterThresholds(
      min: json['min']?.toDouble() ?? 0.0,
      max: json['max']?.toDouble() ?? 0.0,
      enabled: json['enabled'] ?? true,
    );
  }
}

/// Reminder schedules for the four built-in maintenance task types.
///
/// Default frequencies: water change weekly (7 days), filter cleaning monthly
/// (30 days), parameter testing every 3 days, light maintenance every 180 days
/// (disabled by default).
class MaintenanceReminders {
  /// Schedule for the weekly water-change reminder.
  final ReminderSchedule waterChange;

  /// Schedule for the monthly filter-cleaning reminder.
  final ReminderSchedule filterCleaning;

  /// Schedule for the parameter-testing reminder (every 3 days).
  final ReminderSchedule parameterTesting;

  /// Schedule for the light-maintenance reminder (disabled by default).
  final ReminderSchedule lightMaintenance;

  MaintenanceReminders({
    ReminderSchedule? waterChange,
    ReminderSchedule? filterCleaning,
    ReminderSchedule? parameterTesting,
    ReminderSchedule? lightMaintenance,
  }) : waterChange =
           waterChange ?? ReminderSchedule(enabled: true, frequencyDays: 7),
       filterCleaning =
           filterCleaning ?? ReminderSchedule(enabled: true, frequencyDays: 30),
       parameterTesting =
           parameterTesting ??
           ReminderSchedule(enabled: true, frequencyDays: 3),
       lightMaintenance =
           lightMaintenance ??
           ReminderSchedule(enabled: false, frequencyDays: 180);

  MaintenanceReminders copyWith({
    ReminderSchedule? waterChange,
    ReminderSchedule? filterCleaning,
    ReminderSchedule? parameterTesting,
    ReminderSchedule? lightMaintenance,
  }) {
    return MaintenanceReminders(
      waterChange: waterChange ?? this.waterChange,
      filterCleaning: filterCleaning ?? this.filterCleaning,
      parameterTesting: parameterTesting ?? this.parameterTesting,
      lightMaintenance: lightMaintenance ?? this.lightMaintenance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waterChange': waterChange.toJson(),
      'filterCleaning': filterCleaning.toJson(),
      'parameterTesting': parameterTesting.toJson(),
      'lightMaintenance': lightMaintenance.toJson(),
    };
  }

  factory MaintenanceReminders.fromJson(Map<String, dynamic> json) {
    return MaintenanceReminders(
      waterChange: json['waterChange'] != null
          ? ReminderSchedule.fromJson(json['waterChange'])
          : null,
      filterCleaning: json['filterCleaning'] != null
          ? ReminderSchedule.fromJson(json['filterCleaning'])
          : null,
      parameterTesting: json['parameterTesting'] != null
          ? ReminderSchedule.fromJson(json['parameterTesting'])
          : null,
      lightMaintenance: json['lightMaintenance'] != null
          ? ReminderSchedule.fromJson(json['lightMaintenance'])
          : null,
    );
  }
}

/// Defines the timing of a single maintenance reminder notification.
class ReminderSchedule {
  /// Whether this reminder is currently active.
  final bool enabled;

  /// How often (in days) the reminder repeats.
  final int frequencyDays;

  /// Hour of the day (0–23) at which the notification is delivered.
  /// Defaults to 10 (10:00 AM).
  final int hour;

  /// Minute (0–59) at which the notification is delivered. Defaults to 0.
  final int minute;

  ReminderSchedule({
    required this.enabled,
    required this.frequencyDays,
    this.hour = 10,
    this.minute = 0,
  });

  ReminderSchedule copyWith({
    bool? enabled,
    int? frequencyDays,
    int? hour,
    int? minute,
  }) {
    return ReminderSchedule(
      enabled: enabled ?? this.enabled,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'frequencyDays': frequencyDays,
      'hour': hour,
      'minute': minute,
    };
  }

  factory ReminderSchedule.fromJson(Map<String, dynamic> json) {
    return ReminderSchedule(
      enabled: json['enabled'] ?? false,
      frequencyDays: json['frequencyDays'] ?? 7,
      hour: json['hour'] ?? 10,
      minute: json['minute'] ?? 0,
    );
  }
}

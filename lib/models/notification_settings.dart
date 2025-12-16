class NotificationSettings {
  final bool enabledAlerts;
  final bool enabledMaintenance;
  final bool enabledDaily;

  // Soglie parametri
  final ParameterThresholds temperature;
  final ParameterThresholds ph;
  final ParameterThresholds salinity;
  final ParameterThresholds orp;
  final ParameterThresholds calcium;
  final ParameterThresholds magnesium;
  final ParameterThresholds kh;
  final ParameterThresholds nitrate;
  final ParameterThresholds phosphate;

  // Notifiche ricorrenti
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
  }) : temperature = temperature ?? ParameterThresholds(min: 24.0, max: 26.0),
       ph = ph ?? ParameterThresholds(min: 8.0, max: 8.4),
       salinity = salinity ?? ParameterThresholds(min: 1020.0, max: 1028.0),
       orp = orp ?? ParameterThresholds(min: 300.0, max: 400.0),
       calcium = calcium ?? ParameterThresholds(min: 400.0, max: 450.0),
       magnesium = magnesium ?? ParameterThresholds(min: 1250.0, max: 1350.0),
       kh = kh ?? ParameterThresholds(min: 7.0, max: 9.0),
       nitrate = nitrate ?? ParameterThresholds(min: 0.0, max: 10.0),
       phosphate = phosphate ?? ParameterThresholds(min: 0.0, max: 0.1),
       maintenanceReminders = maintenanceReminders ?? MaintenanceReminders();

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

class ParameterThresholds {
  final double min;
  final double max;
  final bool enabled;

  ParameterThresholds({
    required this.min,
    required this.max,
    this.enabled = true,
  });

  bool isOutOfRange(double value) {
    return enabled && (value < min || value > max);
  }

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

class MaintenanceReminders {
  final ReminderSchedule waterChange;
  final ReminderSchedule filterCleaning;
  final ReminderSchedule parameterTesting;
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

class ReminderSchedule {
  final bool enabled;
  final int frequencyDays;
  final int hour;
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

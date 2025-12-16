import 'package:acquariumfe/models/notification_settings.dart';
import 'package:acquariumfe/models/aquarium_parameter.dart';
import 'package:acquariumfe/services/notification_service.dart';

class AlertManager {
  static final AlertManager _instance = AlertManager._internal();
  factory AlertManager() => _instance;
  AlertManager._internal();

  final NotificationService _notificationService = NotificationService();
  NotificationSettings _settings = NotificationSettings();

  // Storico alert (da salvare poi su storage locale)
  final List<AlertLog> _alertHistory = [];

  // Traccia se un parametro è attualmente in stato di allarme (per evitare notifiche duplicate)
  final Map<AquariumParameter, bool> _parameterInAlertState = {};

  /// Inizializza AlertManager
  Future<void> initialize(NotificationSettings settings) async {
    _settings = settings;
    await _notificationService.initialize();
  }

  /// Aggiorna impostazioni
  void updateSettings(NotificationSettings settings) {
    _settings = settings;
  }

  /// Verifica parametro e invia notifica se necessario
  Future<void> checkParameter({
    required AquariumParameter parameter,
    required double value,
    required ParameterThresholds thresholds,
    required String alertTitle,
    required String alertMessage,
  }) async {
    if (!_settings.enabledAlerts || !thresholds.enabled) {
      return;
    }

    if (thresholds.isOutOfRange(value)) {
      // Parametro fuori range

      // Controlla se è già in stato di allarme
      final isAlreadyInAlert = _parameterInAlertState[parameter] ?? false;

      if (!isAlreadyInAlert) {
        await _notificationService.showParameterAlert(
          parameterName: parameter.name,
          currentValue: value,
          minValue: thresholds.min,
          maxValue: thresholds.max,
          unit: parameter.unit,
          alertTitle: alertTitle,
          alertMessage: alertMessage,
        );

        // Marca come "in allarme"
        _parameterInAlertState[parameter] = true;

        // Registra nell'alert history
        _addToHistory(
          AlertLog(
            timestamp: DateTime.now(),
            type: AlertType.parameter,
            title: alertTitle,
            message:
                '$alertMessage: $value${parameter.unit} (range: ${thresholds.min}-${thresholds.max}${parameter.unit})',
            severity: _calculateSeverity(value, thresholds),
          ),
        );
      }
      // Se è già in allarme, non fare nulla (non inviare notifica duplicata)
    } else {
      // Parametro rientrato nella norma: resetta lo stato di allarme
      // così se torna fuori range, invierà una nuova notifica
      _parameterInAlertState[parameter] = false;
    }
  }

  /// Calcola severitÃ  dell'alert
  AlertSeverity _calculateSeverity(
    double value,
    ParameterThresholds thresholds,
  ) {
    final range = thresholds.max - thresholds.min;
    final deviation = value < thresholds.min
        ? (thresholds.min - value)
        : (value - thresholds.max);

    final percentDeviation = (deviation / range) * 100;

    if (percentDeviation > 20) return AlertSeverity.critical;
    if (percentDeviation > 10) return AlertSeverity.high;
    if (percentDeviation > 5) return AlertSeverity.medium;
    return AlertSeverity.low;
  }

  /// Resetta tutti gli stati di allarme (utile per il debug o reset manuale)
  void resetAllAlertStates() {
    _parameterInAlertState.clear();
  }

  /* DEPRECATED - Usare parameter_service._checkAllParametersForAlerts
  /// Verifica tutti i parametri dell'acquario
  Future<void> checkAllParameters(Map<String, double> parameters) async {
    // Questo metodo è deprecato - la logica è stata spostata in parameter_service
  }
  */

  /// Schedula notifiche di manutenzione ricorrenti
  Future<void> scheduleMaintenanceReminders() async {
    if (!_settings.enabledMaintenance) return;

    // Cancella tutte le vecchie notifiche di manutenzione (ID 1000-2000)
    for (int i = 1000; i <= 2000; i++) {
      await _notificationService.cancelNotification(i);
    }

    // Non scheduliamo piÃ¹ notifiche automatiche giornaliere
    // Le notifiche verranno mostrate solo quando l'app verifica
    // attivamente che ci sono task in scadenza (checkAndNotifyDailyTasks)
  }

  /// Verifica se ci sono task da fare oggi e mostra notifica
  Future<void> checkAndNotifyDailyTasks(List<dynamic> tasksToday) async {
    if (!_settings.enabledMaintenance) return;
    if (tasksToday.isEmpty) return;

    final count = tasksToday.length;
    final taskNames = tasksToday
        .take(3)
        .map((t) => t.title as String)
        .join(', ');
    final body = count == 1
        ? tasksToday.first.title
        : count <= 3
        ? taskNames
        : '$taskNames e altre ${count - 3}';

    await _notificationService.showNotification(
      id: 2001,
      title: count == 1
          ? 'Hai 1 task di manutenzione oggi'
          : 'Hai $count task di manutenzione oggi',
      body: body,
      payload: 'maintenance_tasks_today',
    );
  }

  /// Aggiunge alert allo storico
  void _addToHistory(AlertLog log) {
    _alertHistory.insert(0, log);

    // Mantieni solo gli ultimi 100 alert
    if (_alertHistory.length > 100) {
      _alertHistory.removeLast();
    }
  }

  /// Ottieni storico alert
  List<AlertLog> getAlertHistory({int? limit}) {
    if (limit != null && limit < _alertHistory.length) {
      return _alertHistory.sublist(0, limit);
    }
    return List.from(_alertHistory);
  }

  /// Pulisci storico alert
  void clearAlertHistory() {
    _alertHistory.clear();
  }

  /// Ottieni conteggio alert per severitÃ
  Map<AlertSeverity, int> getAlertCountBySeverity() {
    final counts = <AlertSeverity, int>{
      AlertSeverity.low: 0,
      AlertSeverity.medium: 0,
      AlertSeverity.high: 0,
      AlertSeverity.critical: 0,
    };

    for (var alert in _alertHistory) {
      counts[alert.severity] = (counts[alert.severity] ?? 0) + 1;
    }

    return counts;
  }
}

class AlertLog {
  final DateTime timestamp;
  final AlertType type;
  final String title;
  final String message;
  final AlertSeverity severity;

  AlertLog({
    required this.timestamp,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'title': title,
      'message': message,
      'severity': severity.toString(),
    };
  }

  factory AlertLog.fromJson(Map<String, dynamic> json) {
    return AlertLog(
      timestamp: DateTime.parse(json['timestamp']),
      type: AlertType.values.firstWhere((e) => e.toString() == json['type']),
      title: json['title'],
      message: json['message'],
      severity: AlertSeverity.values.firstWhere(
        (e) => e.toString() == json['severity'],
      ),
    );
  }
}

enum AlertType { parameter, maintenance, system }

enum AlertSeverity { low, medium, high, critical }

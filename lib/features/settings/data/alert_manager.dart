/// Manages out-of-range parameter alerts and the in-app alert history.
library;

import 'package:acquariumfe/features/settings/domain/models/notification_settings.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameter.dart';
import 'package:acquariumfe/features/settings/data/notification_service.dart';

/// Singleton that evaluates water-parameter readings against user-defined
/// thresholds and dispatches push notifications when a parameter leaves its
/// acceptable range.
///
/// **Duplicate-suppression:** once a parameter fires an alert, subsequent
/// readings that are still out-of-range are silently ignored. The alert is
/// re-armed only after the parameter returns within range, preventing
/// notification floods.
///
/// **Alert history:** every fired alert is prepended to [_alertHistory].
/// The list is capped at 100 entries; the oldest entry is dropped when the
/// cap is exceeded.
///
/// **Severity:** calculated as the percentage deviation of the measured value
/// beyond the range boundary:
/// - `> 20 %` → [AlertSeverity.critical]
/// - `> 10 %` → [AlertSeverity.high]
/// - `>  5 %` → [AlertSeverity.medium]
/// - otherwise → [AlertSeverity.low]
class AlertManager {
  static final AlertManager _instance = AlertManager._internal();
  factory AlertManager() => _instance;
  AlertManager._internal();

  final NotificationService _notificationService = NotificationService();

  /// Current notification preferences; replaced by [updateSettings].
  NotificationSettings _settings = NotificationSettings();

  /// In-memory alert history; prepend-only, capped at 100 entries.
  final List<AlertLog> _alertHistory = [];

  /// Tracks which parameters are currently out-of-range so that duplicate
  /// notifications are suppressed until the parameter recovers.
  final Map<AquariumParameter, bool> _parameterInAlertState = {};

  /// Initialises the alert manager with [settings] and starts the underlying
  /// [NotificationService].
  ///
  /// Must be called at app start-up before [checkParameter] is invoked.
  Future<void> initialize(NotificationSettings settings) async {
    _settings = settings;
    await _notificationService.initialize();
  }

  /// Replaces the current notification preferences with [settings].
  ///
  /// Changes take effect on the next [checkParameter] call.
  void updateSettings(NotificationSettings settings) {
    _settings = settings;
  }

  /// Evaluates a single parameter reading and sends an alert notification if
  /// all of the following are true:
  /// - [NotificationSettings.enabledAlerts] is `true`
  /// - [thresholds.enabled] is `true`
  /// - [value] is outside `[thresholds.min, thresholds.max]`
  /// - the parameter was **not** already in alert state (duplicate suppression)
  ///
  /// When [value] returns inside range the alert state is cleared, so a future
  /// out-of-range reading will trigger a new notification.
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
      // Parameter is out of range.

      // Only fire if it was previously in a normal state.
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

        // Mark as "in alert" to suppress subsequent duplicate notifications.
        _parameterInAlertState[parameter] = true;

        // Record in the alert history.
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
    } else {
      // Parameter has recovered — re-arm so the next excursion fires again.
      _parameterInAlertState[parameter] = false;
    }
  }

  /// Calculates the [AlertSeverity] of an out-of-range reading as a percentage
  /// of the threshold range width.
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

  /// Clears all in-memory alert states so that the next out-of-range reading
  /// for every parameter will immediately fire a notification.
  ///
  /// Useful for debugging or when the user manually resets the alert panel.
  void resetAllAlertStates() {
    _parameterInAlertState.clear();
  }

  /* DEPRECATED — use parameter_service._checkAllParametersForAlerts instead.
  Future<void> checkAllParameters(Map<String, double> parameters) async { ... }
  */

  /// Cancels all previously scheduled maintenance notifications (IDs 1000–2000)
  /// and no-ops if [NotificationSettings.enabledMaintenance] is `false`.
  ///
  /// **Note:** recurring daily notifications are no longer auto-scheduled here.
  /// Use [checkAndNotifyDailyTasks] instead when the app polls for due tasks.
  Future<void> scheduleMaintenanceReminders() async {
    if (!_settings.enabledMaintenance) return;

    // Cancel all previously scheduled maintenance notifications.
    for (int i = 1000; i <= 2000; i++) {
      await _notificationService.cancelNotification(i);
    }
  }

  /// Shows notification ID `2001` ("Hai N task oggi") when [tasksToday] is
  /// non-empty and [NotificationSettings.enabledMaintenance] is `true`.
  ///
  /// The body lists up to 3 task titles; if there are more it appends
  /// `"e altre N"`.
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

  /// Prepends [log] to [_alertHistory] and trims the list to the most-recent
  /// 100 entries.
  void _addToHistory(AlertLog log) {
    _alertHistory.insert(0, log);

    if (_alertHistory.length > 100) {
      _alertHistory.removeLast();
    }
  }

  /// Returns a defensive copy of the alert history.
  ///
  /// Pass [limit] to retrieve only the most-recent N entries.
  List<AlertLog> getAlertHistory({int? limit}) {
    if (limit != null && limit < _alertHistory.length) {
      return _alertHistory.sublist(0, limit);
    }
    return List.from(_alertHistory);
  }

  /// Removes all entries from [_alertHistory].
  void clearAlertHistory() {
    _alertHistory.clear();
  }

  /// Returns a map of [AlertSeverity] → count across the entire alert history.
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

/// An immutable record of a single fired alert.
///
/// Stored in [AlertManager._alertHistory] and serialisable to/from JSON for
/// optional persistence to local storage.
class AlertLog {
  /// UTC timestamp of when the alert was fired.
  final DateTime timestamp;

  /// Broad category of the alert (parameter, maintenance, system).
  final AlertType type;

  /// Short notification title shown to the user.
  final String title;

  /// Full notification body including measured value and range.
  final String message;

  /// Calculated severity based on percentage deviation from threshold range.
  final AlertSeverity severity;

  AlertLog({
    required this.timestamp,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
  });

  /// Serialises this log entry to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'title': title,
      'message': message,
      'severity': severity.toString(),
    };
  }

  /// Deserialises an [AlertLog] from a JSON map.
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

/// Broad category of an alert log entry.
enum AlertType {
  /// Alert triggered by a water-parameter excursion.
  parameter,

  /// Alert triggered by a missed or overdue maintenance task.
  maintenance,

  /// Alert triggered by an app-level system event.
  system,
}

/// Severity level of an alert, based on percentage deviation from range.
enum AlertSeverity {
  /// < 5 % deviation from the range boundary.
  low,

  /// 5–10 % deviation.
  medium,

  /// 10–20 % deviation.
  high,

  /// > 20 % deviation.
  critical,
}

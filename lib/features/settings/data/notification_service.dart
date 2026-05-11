/// Wrapper around flutter_local_notifications for delivering push notifications.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

/// Singleton that owns the [FlutterLocalNotificationsPlugin] instance and
/// exposes methods for showing, scheduling, and cancelling notifications.
///
/// **Initialisation:** call [initialize] once at app start-up (e.g. inside
/// [AlertManager.initialize]). Subsequent calls are no-ops thanks to the
/// [_isInitialized] guard.
///
/// **Android notification channels:**
/// | Channel ID              | Name                      | Colour     | Usage                          |
/// |-------------------------|---------------------------|------------|--------------------------------|
/// | `aquarium_alerts`       | Acquario Alerts           | `#60a5fa`  | Out-of-range parameter alerts  |
/// | `aquarium_maintenance`  | Manutenzione Acquario     | `#34d399`  | Maintenance reminders & daily  |
/// | `aquarium_recurring`    | Promemoria Ricorrenti     | `#60a5fa`  | Weekly recurring reminders     |
///
/// **Reserved notification IDs:**
/// - `999` — test notification ([showTestNotification])
/// - `2000` — daily maintenance check ([scheduleDailyMaintenanceCheck])
/// - `2001` — today's task summary ([showTestMaintenanceNotification])
///
/// All other IDs are computed as `parameterName.hashCode` by
/// [showParameterAlert].
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// `true` after [initialize] has completed successfully.
  bool _isInitialized = false;

  /// Initialises the notification plugin, timezone data, and OS permissions.
  ///
  /// - **Android:** uses `@mipmap/ic_launcher` as the notification icon.
  /// - **iOS:** requests alert, badge, and sound permissions immediately.
  ///
  /// This method is idempotent — calling it multiple times has no effect after
  /// the first successful call.
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await requestPermissions();

    _isInitialized = true;
  }

  /// Callback invoked when the user taps a notification.
  ///
  /// Currently a no-op; extend this to navigate based on
  /// [NotificationResponse.payload].
  void _onNotificationTapped(NotificationResponse response) {}

  /// Requests the system notification permission via `permission_handler`.
  ///
  /// Returns `true` if permission is granted (either already was, or just
  /// granted by the user).
  Future<bool> requestPermissions() async {
    if (await Permission.notification.isGranted) {
      return true;
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Displays an immediate notification with the given [id], [title], [body],
  /// and optional [payload].
  ///
  /// Uses the `aquarium_alerts` Android channel. Silently returns when
  /// [initialize] has not been called yet.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    if (!_isInitialized) {
      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'aquarium_alerts',
          'Acquario Alerts',
          channelDescription: 'Notifiche per parametri acquario fuori range',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF60a5fa),
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Displays a parameter-alert notification.
  ///
  /// The notification ID is `parameterName.hashCode` so that two alerts for
  /// the same parameter replace each other rather than stacking.
  /// The payload is `'parameter_$parameterName'`.
  Future<void> showParameterAlert({
    required String parameterName,
    required double currentValue,
    required double minValue,
    required double maxValue,
    required String unit,
    required String alertTitle,
    required String alertMessage,
  }) async {
    await showNotification(
      id: parameterName.hashCode,
      title: alertTitle,
      body: alertMessage,
      payload: 'parameter_$parameterName',
      priority: NotificationPriority.max,
    );
  }

  /// Schedules a one-time maintenance notification at [scheduledDate].
  ///
  /// Uses the `aquarium_maintenance` Android channel. The notification is
  /// delivered even while the device is in doze mode
  /// (`exactAllowWhileIdle`).
  Future<void> scheduleMaintenanceNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'aquarium_maintenance',
          'Manutenzione Acquario',
          channelDescription: 'Reminder per manutenzione acquario',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF34d399),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedules a weekly recurring notification that fires every [weekday] at
  /// [hour]:[minute] (24-hour clock).
  ///
  /// [weekday] follows ISO 8601: 1 = Monday, 7 = Sunday.
  /// Uses the `aquarium_recurring` Android channel.
  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int weekday,
    required int hour,
    required int minute,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfWeekday(weekday, hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'aquarium_recurring',
          'Promemoria Ricorrenti',
          channelDescription: 'Notifiche ricorrenti per test e manutenzione',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF60a5fa),
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Returns the next [tz.TZDateTime] that falls on [weekday] at [hour]:[minute]
  /// in the device's local timezone, advancing by 7 days if the calculated
  /// time is already in the past.
  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  /// Cancels the notification with the given [id].
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancels all pending and delivered notifications.
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Returns the list of currently scheduled (pending) notifications.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Schedules or re-schedules the daily maintenance-check notification
  /// (ID `2000`) to fire at [hour]:[minute] every day.
  ///
  /// Any previously scheduled notification with ID `2000` is cancelled first.
  /// If the specified time has already passed today, the notification is
  /// scheduled for the following day.
  Future<void> scheduleDailyMaintenanceCheck({
    required int hour,
    required int minute,
  }) async {
    await cancelNotification(2000);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'aquarium_maintenance',
          'Manutenzione Acquario',
          channelDescription: 'Promemoria giornaliero per task di manutenzione',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF8b5cf6),
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      2000,
      'Manutenzione Acquario',
      'Hai task da completare oggi',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'maintenance_daily',
    );
  }

  /// Shows an immediate test notification (ID `999`).
  ///
  /// Used during development and in the notification settings screen to verify
  /// that the notification pipeline is working.
  Future<void> showTestNotification() async {
    await showNotification(
      id: 999,
      title: 'Test Notifica',
      body: 'Questa è una notifica di test dal sistema AcquariumFE',
      payload: 'test',
    );
  }

  /// Shows a test maintenance-task notification (ID `2001`) with [taskCount]
  /// simulated tasks.
  ///
  /// The body lists up to 3 sample task names; if [taskCount] > 3 it appends
  /// `"e altre N"`.
  Future<void> showTestMaintenanceNotification({int taskCount = 3}) async {
    final tasks = [
      'Cambio acqua 20%',
      'Test pH e KH',
      'Pulizia filtro',
      'Controllo coralli',
      'Dosaggio calcio',
    ];

    final body = taskCount == 1
        ? tasks.first
        : taskCount <= 3
        ? tasks.take(taskCount).join(', ')
        : '${tasks.take(3).join(', ')} e altre ${taskCount - 3}';

    await showNotification(
      id: 2001,
      title: taskCount == 1
          ? 'Hai 1 task di manutenzione oggi'
          : 'Hai $taskCount task di manutenzione oggi',
      body: body,
      payload: 'maintenance_tasks_today',
    );
  }
}

/// Semantic priority hint passed to [NotificationService.showNotification].
///
/// Maps conceptually to Android's [Priority] levels. Currently only [max] is
/// used (for parameter alerts); the rest are reserved for future use.
enum NotificationPriority {
  /// Lowest visible priority.
  min,

  /// Below-normal priority.
  low,

  /// Default priority.
  normal,

  /// High priority — used for most app notifications.
  high,

  /// Maximum priority — used for critical parameter alerts.
  max,
}

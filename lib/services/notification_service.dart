import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // Emoji per ogni tipo di parametro
  static const Map<String, String> _parameterEmojis = {
    'Temperatura': '🌡️',
    'pH': '💧',
    'Salinità': '🌊',
    'ORP': '⚡',
    'Calcio': '🦴',
    'Magnesio': '🧪',
    'KH': '📊',
    'Nitrati': '🔬',
    'Fosfati': '⚗️',
  };

  /// Inizializza il servizio notifiche
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Inizializza timezone
    tz.initializeTimeZones();

    // Configurazione Android
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configurazione iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
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

    // Richiedi permessi
    await requestPermissions();

    _isInitialized = true;
  }

  /// Gestisce il tap sulla notifica
  void _onNotificationTapped(NotificationResponse response) {
    
  }

  /// Richiedi permessi notifiche
  Future<bool> requestPermissions() async {
    if (await Permission.notification.isGranted) {
      return true;
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Mostra notifica immediata
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
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

  /// Mostra notifica di alert parametri con indicazione se troppo basso/alto
  Future<void> showParameterAlert({
    required String parameterName,
    required double currentValue,
    required double minValue,
    required double maxValue,
    required String unit,
  }) async {
    // Determina se il valore è troppo basso o troppo alto
    String alertType;
    String directionEmoji;
    String recommendation;
    
    if (currentValue < minValue) {
      alertType = 'TROPPO BASSO';
      directionEmoji = '⬇️';
      recommendation = 'Aumentare a ${((minValue + maxValue) / 2).toStringAsFixed(1)}$unit';
    } else if (currentValue > maxValue) {
      alertType = 'TROPPO ALTO';
      directionEmoji = '⬆️';
      recommendation = 'Ridurre a ${((minValue + maxValue) / 2).toStringAsFixed(1)}$unit';
    } else {
      // Valore nel range (non dovrebbe succedere)
      alertType = 'NEL RANGE';
      directionEmoji = '✅';
      recommendation = 'Tutto ok';
    }
    
    // Emoji specifico per il parametro
    final parameterEmoji = _parameterEmojis[parameterName] ?? '📊';
    
    await showNotification(
      id: parameterName.hashCode,
      title: '$parameterEmoji $parameterName $directionEmoji $alertType',
      body: 'Attuale: $currentValue$unit | Range: $minValue-$maxValue$unit\n💡 $recommendation',
      payload: 'parameter_$parameterName',
      priority: NotificationPriority.max,
    );
  }

  /// Schedula notifica periodica (es. manutenzione)
  Future<void> scheduleMaintenanceNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedula notifica ricorrente settimanale
  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int weekday, // 1=Monday, 7=Sunday
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Calcola prossima istanza del giorno della settimana
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

  /// Cancella notifica specifica
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancella tutte le notifiche
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Ottieni notifiche pending
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Test notifica immediata (per debug)
  Future<void> showTestNotification() async {
    await showNotification(
      id: 999,
      title: '🧪 Test Notifica',
      body: 'Questa è una notifica di test dal sistema AcquariumFE',
      payload: 'test',
    );
  }
}

enum NotificationPriority {
  min,
  low,
  normal,
  high,
  max,
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings: settings);
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'demo_channel',
        'Demo Notifications',
        channelDescription: 'Notifications for the demo app',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(id: 0, title: title, body: body, notificationDetails: details);
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'demo_channel',
        'Demo Notifications',
        channelDescription: 'Notifications for the demo app',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await Future.delayed(delay);
    await _plugin.show(id: 1, title: title, body: body, notificationDetails: details);
  }
}

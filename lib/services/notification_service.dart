import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings: settings);
  }

  static const _androidDetails = AndroidNotificationDetails(
    'demo_channel',
    'Demo Notifications',
    channelDescription: 'Notifications for the demo app',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@drawable/ic_notification',
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
  );

  static const _notificationDetails = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
        id: 0, title: title, body: body, notificationDetails: _notificationDetails);
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    await Future.delayed(delay);
    await _plugin.show(
        id: 1, title: title, body: body, notificationDetails: _notificationDetails);
  }
}

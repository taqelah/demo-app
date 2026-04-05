import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/test_keys.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _statusText = 'No notifications sent yet';

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (mounted) {
        if (result.isGranted) {
          setState(() => _statusText = 'Notification permission granted');
        } else {
          setState(() =>
              _statusText = 'Notification permission denied — notifications may not appear');
        }
      }
    }
  }

  void _sendInstant() {
    NotificationService.showInstantNotification(
      title: 'DemoApp Notification',
      body: 'This is an instant notification from the demo app!',
    );
    setState(() => _statusText = 'Instant notification sent!');
  }

  void _sendScheduled() {
    NotificationService.scheduleNotification(
      title: 'Scheduled Notification',
      body: 'This notification was scheduled 5 seconds ago!',
      delay: const Duration(seconds: 5),
    );
    setState(() => _statusText = 'Notification scheduled (5 seconds)...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Trigger local notifications to test notification handling '
              'with Appium\'s openNotifications() and notification tray inspection.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _statusText,
                  key: TestKeys.notificationStatusText,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              key: TestKeys.notificationInstantButton,
              onPressed: _sendInstant,
              icon: const Icon(Icons.notifications_active),
              label: const Text('Send Instant Notification'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              key: TestKeys.notificationScheduleButton,
              onPressed: _sendScheduled,
              icon: const Icon(Icons.schedule),
              label: const Text('Schedule Notification (5 sec)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

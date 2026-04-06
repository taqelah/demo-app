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
          setState(
              () => _statusText = 'Permission denied — notifications may not appear');
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

  void _showInAppBanner() {
    setState(() => _statusText = 'In-app banner shown!');
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/images/logo.png', width: 40, height: 40),
        ),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('DemoApp',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 2),
            Text('You have a new in-app notification!',
                style: TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('DISMISS'),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              if (mounted) {
                setState(() => _statusText = 'Banner action tapped!');
              }
            },
            child: const Text('VIEW'),
          ),
        ],
      ),
    );
  }

  void _showInAppDialog() {
    setState(() => _statusText = 'In-app dialog shown!');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  Image.asset('assets/images/logo.png', width: 32, height: 32),
            ),
            const SizedBox(width: 12),
            const Text('DemoApp'),
          ],
        ),
        content: const Text(
            'This is an in-app notification dialog. It can show important alerts without leaving the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('LATER'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (mounted) {
                setState(() => _statusText = 'Dialog action tapped!');
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInAppSnackbar() {
    setState(() => _statusText = 'In-app snackbar shown!');
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child:
                  Image.asset('assets/images/logo.png', width: 24, height: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
                child: Text('New message from DemoApp!')),
          ],
        ),
        action: SnackBarAction(
          label: 'VIEW',
          onPressed: () {
            if (mounted) {
              setState(() => _statusText = 'Snackbar action tapped!');
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Test system and in-app notifications for automation.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
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

          // System notifications section
          Text('System Notifications',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            key: TestKeys.notificationInstantButton,
            onPressed: _sendInstant,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
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

          const SizedBox(height: 24),

          // In-app notifications section
          Text('In-App Notifications',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _showInAppBanner,
            icon: const Icon(Icons.campaign),
            label: const Text('Show Banner Notification'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _showInAppDialog,
            icon: const Icon(Icons.announcement),
            label: const Text('Show Dialog Notification'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _showInAppSnackbar,
            icon: const Icon(Icons.message),
            label: const Text('Show Snackbar Notification'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

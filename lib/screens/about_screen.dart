import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../main.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              key: TestKeys.aboutLogo,
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'DemoApp',
              key: TestKeys.aboutAppName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'by taqelah! community',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              key: TestKeys.aboutVersion,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            Card(
              key: TestKeys.aboutDescriptionCard,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.school,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Master Mobile UI Automation',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A demo app from the taqelah! community for those '
                      'who want to master mobile UI test automation. '
                      'Practice with real-world e-commerce flows, gestures, '
                      'forms, permissions, notifications, and more — all '
                      'built with automation-friendly test IDs.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'What You Can Practice',
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 12),
                    _featureRow(context, Icons.shopping_bag,
                        'E-commerce flow (browse, cart, checkout)'),
                    _featureRow(context, Icons.swipe,
                        'Gestures (swipe, drag, long-press, pinch)'),
                    _featureRow(context, Icons.edit_note,
                        'Form validation & input types'),
                    _featureRow(context, Icons.web,
                        'WebView & hybrid app testing'),
                    _featureRow(context, Icons.notifications,
                        'System & in-app notifications'),
                    _featureRow(context, Icons.camera_alt,
                        'Camera & location access'),
                    _featureRow(context, Icons.security,
                        'Permission handling'),
                    _featureRow(context, Icons.tab,
                        'Tabs, navigation & dialogs'),
                    _featureRow(context, Icons.dark_mode,
                        'Dark mode & theme switching'),
                    _featureRow(context, Icons.key,
                        '200+ Appium-ready test Keys'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                key: TestKeys.aboutDarkModeSwitch,
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                value: themeController.isDarkMode,
                onChanged: (value) {
                  themeController.toggleTheme(value);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'www.taqelah.sg',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 20),
                const SizedBox(width: 8),
                Text(
                  'Built with Flutter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

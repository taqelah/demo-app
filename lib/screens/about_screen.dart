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
            const SizedBox(height: 24),
            ClipRRect(
              key: TestKeys.aboutLogo,
              borderRadius: BorderRadius.circular(16),
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
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              key: TestKeys.aboutVersion,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            Card(
              key: TestKeys.aboutDescriptionCard,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Your one-stop destination for women\'s fashion. '
                  'Browse the latest dresses, from casual sundresses to elegant evening gowns. '
                  'Built with Flutter for a seamless shopping experience on any device.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 24),
                const SizedBox(width: 8),
                Text(
                  'Built with Flutter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

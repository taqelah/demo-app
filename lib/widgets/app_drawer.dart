import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../main.dart';
import '../services/local_storage_service.dart';
import 'test_id.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await LocalStorageService.getUsername();
    if (mounted) {
      setState(() {
        _username = username ?? 'Guest';
      });
    }
  }

  Future<void> _logout() async {
    await LocalStorageService.clearAll();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _navigateTo(String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.of(context);

    return Drawer(
      child: ListView(
        // Keep the header flush with the status bar, but reserve room at the
        // bottom so the last tile clears the system navigation bar and stays
        // tappable.
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TestId(
                  TestKeys.drawerLogo,
                  child: ClipRRect(
                    key: TestKeys.drawerLogo,
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TestId(
                  TestKeys.drawerUsername,
                  child: Text(
                    _username,
                    key: TestKeys.drawerUsername,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TestId(
            TestKeys.drawerCatalogTile,
            child: ListTile(
              key: TestKeys.drawerCatalogTile,
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              },
            ),
          ),
          TestId(
            TestKeys.drawerCartTile,
            child: ListTile(
              key: TestKeys.drawerCartTile,
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () => _navigateTo('/cart'),
            ),
          ),
          TestId(
            TestKeys.drawerAboutTile,
            child: ListTile(
              key: TestKeys.drawerAboutTile,
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => _navigateTo('/about'),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text(
              'TEST SCREENS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                letterSpacing: 1,
              ),
            ),
          ),
          TestId(
            TestKeys.drawerGesturesTile,
            child: ListTile(
              key: TestKeys.drawerGesturesTile,
              leading: const Icon(Icons.swipe),
              title: const Text('Gestures'),
              onTap: () => _navigateTo('/gestures'),
            ),
          ),
          TestId(
            TestKeys.drawerWebViewTile,
            child: ListTile(
              key: TestKeys.drawerWebViewTile,
              leading: const Icon(Icons.web),
              title: const Text('WebView'),
              onTap: () => _navigateTo('/webview'),
            ),
          ),
          TestId(
            TestKeys.drawerDialogsTile,
            child: ListTile(
              key: TestKeys.drawerDialogsTile,
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Dialogs & Alerts'),
              onTap: () => _navigateTo('/dialogs'),
            ),
          ),
          TestId(
            TestKeys.drawerFormTile,
            child: ListTile(
              key: TestKeys.drawerFormTile,
              leading: const Icon(Icons.edit_note),
              title: const Text('Form Validation'),
              onTap: () => _navigateTo('/form-showcase'),
            ),
          ),
          TestId(
            TestKeys.drawerPermissionsTile,
            child: ListTile(
              key: TestKeys.drawerPermissionsTile,
              leading: const Icon(Icons.security),
              title: const Text('Permissions'),
              onTap: () => _navigateTo('/permissions'),
            ),
          ),
          TestId(
            TestKeys.drawerNotificationsTile,
            child: ListTile(
              key: TestKeys.drawerNotificationsTile,
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () => _navigateTo('/notifications'),
            ),
          ),
          TestId(
            TestKeys.drawerTabsTile,
            child: ListTile(
              key: TestKeys.drawerTabsTile,
              leading: const Icon(Icons.tab),
              title: const Text('Tabs & Navigation'),
              onTap: () => _navigateTo('/tabs-navigation'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => _navigateTo('/camera'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Location'),
            onTap: () => _navigateTo('/location'),
          ),
          const Divider(),
          TestId(
            TestKeys.drawerDarkModeSwitch,
            child: SwitchListTile(
              key: TestKeys.drawerDarkModeSwitch,
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              value: themeController.isDarkMode,
              onChanged: (value) {
                themeController.toggleTheme(value);
              },
            ),
          ),
          const Divider(),
          TestId(
            TestKeys.drawerLogoutTile,
            child: ListTile(
              key: TestKeys.drawerLogoutTile,
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../main.dart';
import '../services/local_storage_service.dart';

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
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  key: TestKeys.drawerLogo,
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _username,
                  key: TestKeys.drawerUsername,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            key: TestKeys.drawerCatalogTile,
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
          ),
          ListTile(
            key: TestKeys.drawerCartTile,
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () => _navigateTo('/cart'),
          ),
          ListTile(
            key: TestKeys.drawerAboutTile,
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => _navigateTo('/about'),
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
          ListTile(
            key: TestKeys.drawerGesturesTile,
            leading: const Icon(Icons.swipe),
            title: const Text('Gestures'),
            onTap: () => _navigateTo('/gestures'),
          ),
          ListTile(
            key: TestKeys.drawerWebViewTile,
            leading: const Icon(Icons.web),
            title: const Text('WebView'),
            onTap: () => _navigateTo('/webview'),
          ),
          ListTile(
            key: TestKeys.drawerDialogsTile,
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('Dialogs & Alerts'),
            onTap: () => _navigateTo('/dialogs'),
          ),
          ListTile(
            key: TestKeys.drawerFormTile,
            leading: const Icon(Icons.edit_note),
            title: const Text('Form Validation'),
            onTap: () => _navigateTo('/form-showcase'),
          ),
          ListTile(
            key: TestKeys.drawerPermissionsTile,
            leading: const Icon(Icons.security),
            title: const Text('Permissions'),
            onTap: () => _navigateTo('/permissions'),
          ),
          ListTile(
            key: TestKeys.drawerNotificationsTile,
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () => _navigateTo('/notifications'),
          ),
          ListTile(
            key: TestKeys.drawerTabsTile,
            leading: const Icon(Icons.tab),
            title: const Text('Tabs & Navigation'),
            onTap: () => _navigateTo('/tabs-navigation'),
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
          SwitchListTile(
            key: TestKeys.drawerDarkModeSwitch,
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: themeController.isDarkMode,
            onChanged: (value) {
              themeController.toggleTheme(value);
            },
          ),
          const Divider(),
          ListTile(
            key: TestKeys.drawerLogoutTile,
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}

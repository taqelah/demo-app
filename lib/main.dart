import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/product_catalog_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_info_screen.dart';
import 'screens/checkout_review_screen.dart';
import 'screens/checkout_complete_screen.dart';
import 'screens/about_screen.dart';
import 'screens/gesture_demo_screen.dart';
import 'screens/webview_screen.dart';
import 'screens/dialog_showcase_screen.dart';
import 'screens/form_showcase_screen.dart';
import 'screens/permission_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/tabs_navigation_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/location_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const LimeDemoApp());
}

class ThemeController extends InheritedWidget {
  final void Function(bool isDark) toggleTheme;
  final bool isDarkMode;

  const ThemeController({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required super.child,
  });

  static ThemeController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeController>()!;
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
}

class LimeDemoApp extends StatefulWidget {
  const LimeDemoApp({super.key});

  @override
  State<LimeDemoApp> createState() => _LimeDemoAppState();
}

class _LimeDemoAppState extends State<LimeDemoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await LocalStorageService.getThemeIsDark();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    LocalStorageService.saveThemeMode(isDark);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      toggleTheme: _toggleTheme,
      isDarkMode: _themeMode == ThemeMode.dark,
      child: MaterialApp(
        title: 'DemoApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/catalog': (context) => const ProductCatalogScreen(),
          '/product-detail': (context) => const ProductDetailScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout-info': (context) => const CheckoutInfoScreen(),
          '/checkout-review': (context) => const CheckoutReviewScreen(),
          '/checkout-complete': (context) => const CheckoutCompleteScreen(),
          '/about': (context) => const AboutScreen(),
          '/gestures': (context) => const GestureDemoScreen(),
          '/webview': (context) => const WebViewScreen(),
          '/dialogs': (context) => const DialogShowcaseScreen(),
          '/form-showcase': (context) => const FormShowcaseScreen(),
          '/permissions': (context) => const PermissionScreen(),
          '/notifications': (context) => const NotificationScreen(),
          '/tabs-navigation': (context) => const TabsNavigationScreen(),
          '/camera': (context) => const CameraScreen(),
          '/location': (context) => const LocationScreen(),
        },
      ),
    );
  }
}

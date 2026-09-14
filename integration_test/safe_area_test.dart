// Verifies that the bottom-anchored controls on each screen stay clear of the
// system inset (Android navigation bar / iOS home indicator).
//
// Run on a booted device:
//   flutter test integration_test/safe_area_test.dart -d <device-id>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:lime_demo_app/constants/app_constants.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/screens/cart_screen.dart';
import 'package:lime_demo_app/screens/product_detail_screen.dart';
import 'package:lime_demo_app/models/product.dart';
import 'package:lime_demo_app/widgets/app_drawer.dart';
import 'package:lime_demo_app/models/cart_item.dart';
import 'package:lime_demo_app/services/local_storage_service.dart';
import 'package:lime_demo_app/main.dart' show ThemeController;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Bottom edge of the usable area: screen height minus the system inset.
  double safeBottom(WidgetTester tester) {
    final view = tester.view;
    final height = view.physicalSize.height / view.devicePixelRatio;
    final inset = view.viewPadding.bottom / view.devicePixelRatio;
    return height - inset;
  }

  Future<void> pumpScreen(WidgetTester tester, Widget home,
      {RouteSettings? settings}) async {
    await tester.pumpWidget(ThemeController(
      isDarkMode: false,
      toggleTheme: (_) {},
      child: MaterialApp(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => home,
          settings: settings ?? const RouteSettings(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('device reports a bottom inset', (tester) async {
    final inset = tester.view.viewPadding.bottom / tester.view.devicePixelRatio;
    debugPrint('BOTTOM INSET = ${inset.toStringAsFixed(1)} logical px');
    expect(inset, greaterThan(0),
        reason: 'This device has no bottom inset, so the bug cannot manifest '
            'here and this run proves nothing. Use a device with a gesture '
            'bar / home indicator / 3-button nav bar.');
  });

  testWidgets('product detail: Add to Cart clears the inset', (tester) async {
    final Product product = AppConstants.products.first;
    await pumpScreen(tester, const ProductDetailScreen(),
        settings: RouteSettings(arguments: product));

    final rect = tester.getRect(find.byKey(TestKeys.detailAddToCartButton));
    final limit = safeBottom(tester);
    debugPrint('ADD TO CART bottom=${rect.bottom.toStringAsFixed(1)} '
        'safeBottom=${limit.toStringAsFixed(1)}');
    expect(rect.bottom, lessThanOrEqualTo(limit),
        reason: 'Add to Cart extends ${(rect.bottom - limit).toStringAsFixed(1)}px '
            'into the system inset');
  });

  testWidgets('cart: Proceed to Checkout clears the inset', (tester) async {
    // Seed a cart item, otherwise the screen renders its empty state and the
    // checkout button never exists.
    await LocalStorageService.saveCart(
        [CartItem(
      product: AppConstants.products.first,
      quantity: 1,
      selectedColor: AppConstants.products.first.availableColors.first,
    )]);

    await pumpScreen(tester, const CartScreen());
    await tester.pumpAndSettle();

    final finder = find.byKey(TestKeys.cartCheckoutButton);
    expect(finder, findsOneWidget,
        reason: 'cart seeding failed - checkout button not rendered');
    final rect = tester.getRect(finder);
    final limit = safeBottom(tester);
    debugPrint('CHECKOUT bottom=${rect.bottom.toStringAsFixed(1)} '
        'safeBottom=${limit.toStringAsFixed(1)}');
    expect(rect.bottom, lessThanOrEqualTo(limit),
        reason: 'Proceed to Checkout extends '
            '${(rect.bottom - limit).toStringAsFixed(1)}px into the system inset');
  });

  testWidgets('drawer: Logout scrolls fully clear of the inset', (tester) async {
    // Exercise the drawer in isolation: HomeScreen depends on app-level
    // startup state that a bare pump does not provide.
    await pumpScreen(tester, const Scaffold(drawer: AppDrawer(), body: SizedBox()));

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    final logout = find.byKey(TestKeys.drawerLogoutTile);
    await tester.scrollUntilVisible(logout, 300,
        scrollable: find.descendant(
            of: find.byType(AppDrawer), matching: find.byType(Scrollable)));
    await tester.pumpAndSettle();

    final rect = tester.getRect(logout);
    final limit = safeBottom(tester);
    debugPrint('LOGOUT bottom=${rect.bottom.toStringAsFixed(1)} '
        'safeBottom=${limit.toStringAsFixed(1)}');
    expect(rect.bottom, lessThanOrEqualTo(limit),
        reason: 'Logout extends ${(rect.bottom - limit).toStringAsFixed(1)}px '
            'into the system inset');
  });
}

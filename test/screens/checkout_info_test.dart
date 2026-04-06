import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/screens/checkout_info_screen.dart';

Widget _buildTestApp() {
  return MaterialApp(
    home: const CheckoutInfoScreen(),
    routes: {
      '/checkout-review': (_) => const Scaffold(body: Text('Review')),
    },
  );
}

void main() {
  group('CheckoutInfoScreen', () {
    testWidgets('should render all form fields', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.checkoutInfoTitle), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoFullName), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoAddress1), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoAddress2), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoCity), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoState), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoZip), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoCountry), findsOneWidget);
      expect(find.byKey(TestKeys.checkoutInfoProceedButton), findsOneWidget);
    });

    testWidgets('should show validation errors on empty submit',
        (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(TestKeys.checkoutInfoProceedButton));
      await tester.pumpAndSettle();

      // All required fields should show errors
      expect(find.text('This field is required'), findsWidgets);
    });

    testWidgets('should accept valid input', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(TestKeys.checkoutInfoFullName), 'Jane Doe');
      await tester.enterText(
          find.byKey(TestKeys.checkoutInfoAddress1), '123 Main St');
      await tester.enterText(
          find.byKey(TestKeys.checkoutInfoCity), 'Singapore');
      await tester.enterText(
          find.byKey(TestKeys.checkoutInfoState), 'SG');
      await tester.enterText(
          find.byKey(TestKeys.checkoutInfoZip), '123456');
      await tester.enterText(
          find.byKey(TestKeys.checkoutInfoCountry), 'Singapore');

      await tester.tap(find.byKey(TestKeys.checkoutInfoProceedButton));
      await tester.pumpAndSettle();

      // Should navigate to review (no validation errors)
      expect(find.text('This field is required'), findsNothing);
    });
  });
}

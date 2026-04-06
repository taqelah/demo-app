import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/screens/checkout_complete_screen.dart';

Widget _buildTestApp() {
  return MaterialApp(
    home: const CheckoutCompleteScreen(),
    routes: {
      '/home': (_) => const Scaffold(body: Text('Home')),
    },
  );
}

void main() {
  group('CheckoutCompleteScreen', () {
    testWidgets('should render success elements', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.completeSuccessIcon), findsOneWidget);
      expect(find.byKey(TestKeys.completeThankYouText), findsOneWidget);
      expect(find.byKey(TestKeys.completeMessageText), findsOneWidget);
      expect(find.byKey(TestKeys.completeContinueButton), findsOneWidget);
    });

    testWidgets('should show thank you message', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Thank You!'), findsOneWidget);
      expect(find.textContaining('order has been placed'), findsOneWidget);
      expect(find.text('Continue Shopping'), findsOneWidget);
    });
  });
}

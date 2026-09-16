import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/app_constants.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildTestApp({Object? args}) {
  return MaterialApp(
    onGenerateRoute: (_) => MaterialPageRoute(
      builder: (_) => const HomeScreen(),
      settings: RouteSettings(arguments: args),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'is_logged_in': true,
      'username': AppConstants.validUsername,
    });
  });

  group('HomeScreen welcome dialog', () {
    testWidgets('should greet the user by name once home has loaded',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(args: const HomeArgs(showWelcome: true)));
      await tester.pumpAndSettle();

      // Home itself is rendered behind the dialog.
      expect(find.text('Shop by Category'), findsOneWidget);
      expect(find.byKey(TestKeys.homeWelcomeDialog), findsOneWidget);
      expect(find.byKey(TestKeys.homeWelcomeMessage), findsOneWidget);
      expect(find.text('Welcome, Emma!'), findsOneWidget);
    });

    testWidgets('should not greet without the welcome flag', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.homeWelcomeDialog), findsNothing);
    });

    testWidgets('should not greet on an auto-login resumed from storage',
        (tester) async {
      await tester
          .pumpWidget(_buildTestApp(args: const HomeArgs(showWelcome: false)));
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.homeWelcomeDialog), findsNothing);
    });

    testWidgets('start shopping should dismiss the greeting', (tester) async {
      await tester.pumpWidget(_buildTestApp(args: const HomeArgs(showWelcome: true)));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(TestKeys.homeWelcomeContinueButton));
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.homeWelcomeDialog), findsNothing);
      expect(find.text('Shop by Category'), findsOneWidget);
    });

    testWidgets('barrier tap should not dismiss the greeting', (tester) async {
      await tester.pumpWidget(_buildTestApp(args: const HomeArgs(showWelcome: true)));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.homeWelcomeDialog), findsOneWidget);
    });

    testWidgets('system back should not dismiss the greeting', (tester) async {
      await tester.pumpWidget(_buildTestApp(args: const HomeArgs(showWelcome: true)));
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.homeWelcomeDialog), findsOneWidget);
    });

    testWidgets('should fall back to a neutral greeting without a username',
        (tester) async {
      SharedPreferences.setMockInitialValues({'is_logged_in': true});

      await tester.pumpWidget(_buildTestApp(args: const HomeArgs(showWelcome: true)));
      await tester.pumpAndSettle();

      expect(find.text('Welcome, there!'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/screens/login_screen.dart';

Widget _buildTestApp({Widget? child}) {
  return MaterialApp(
    home: child ?? const LoginScreen(),
    routes: {
      '/home': (_) => const Scaffold(body: Text('Home')),
      '/catalog': (_) => const Scaffold(body: Text('Catalog')),
    },
  );
}

void main() {
  group('LoginScreen', () {
    testWidgets('should render all login elements', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.loginLogo), findsOneWidget);
      expect(find.byKey(TestKeys.loginAppName), findsOneWidget);
      expect(find.byKey(TestKeys.loginSubtitle), findsOneWidget);
      expect(find.byKey(TestKeys.loginUsernameField), findsOneWidget);
      expect(find.byKey(TestKeys.loginPasswordField), findsOneWidget);
      expect(find.byKey(TestKeys.loginButton), findsOneWidget);
      expect(find.byKey(TestKeys.loginCredentialsHint), findsOneWidget);
    });

    testWidgets('should show app name DemoApp', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('DemoApp'), findsOneWidget);
    });

    testWidgets('should show demo credentials hint', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Demo Credentials'), findsOneWidget);
      expect(find.textContaining('emma@demoapp.com'), findsOneWidget);
      expect(find.textContaining('10203040'), findsOneWidget);
    });

    testWidgets('should show validation errors on empty submit',
        (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(TestKeys.loginButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show error on wrong credentials', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(TestKeys.loginUsernameField), 'wrong@email.com');
      await tester.enterText(
          find.byKey(TestKeys.loginPasswordField), 'wrongpass');
      await tester.tap(find.byKey(TestKeys.loginButton));
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.loginErrorMessage), findsOneWidget);
      expect(find.textContaining('Invalid username or password'), findsOneWidget);
    });

    testWidgets('password toggle should work', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // Initially obscured
      final passwordField = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(TestKeys.loginPasswordField),
          matching: find.byType(EditableText),
        ),
      );
      expect(passwordField.obscureText, true);

      // Tap toggle
      await tester.tap(find.byKey(TestKeys.loginPasswordToggle));
      await tester.pumpAndSettle();

      final passwordFieldAfter = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(TestKeys.loginPasswordField),
          matching: find.byType(EditableText),
        ),
      );
      expect(passwordFieldAfter.obscureText, false);
    });
  });
}

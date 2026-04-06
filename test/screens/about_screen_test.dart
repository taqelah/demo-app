import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/main.dart';
import 'package:lime_demo_app/screens/about_screen.dart';

Widget _buildTestApp() {
  return MaterialApp(
    home: ThemeController(
      toggleTheme: (_) {},
      isDarkMode: false,
      child: const AboutScreen(),
    ),
  );
}

void main() {
  group('AboutScreen', () {
    testWidgets('should render all about elements', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byKey(TestKeys.aboutLogo), findsOneWidget);
      expect(find.byKey(TestKeys.aboutAppName), findsOneWidget);
      expect(find.byKey(TestKeys.aboutVersion), findsOneWidget);
      expect(find.byKey(TestKeys.aboutDescriptionCard), findsOneWidget);
      expect(find.byKey(TestKeys.aboutDarkModeSwitch), findsOneWidget);
    });

    testWidgets('should show app name and version', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('DemoApp'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);
    });

    testWidgets('should show taqelah community', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('by taqelah! community'), findsOneWidget);
    });

    testWidgets('should show feature list', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('What You Can Practice'), findsOneWidget);
      expect(find.textContaining('E-commerce flow'), findsOneWidget);
      expect(find.textContaining('Gestures'), findsOneWidget);
      expect(find.textContaining('Form validation'), findsOneWidget);
    });

    testWidgets('should show website', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('www.taqelah.sg'), findsOneWidget);
    });

    testWidgets('dark mode switch should be present', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Dark Mode'), findsOneWidget);
      final switchWidget = tester.widget<SwitchListTile>(
        find.byKey(TestKeys.aboutDarkModeSwitch),
      );
      expect(switchWidget.value, false);
    });
  });
}

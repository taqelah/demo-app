import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/screens/login_screen.dart';
import 'package:lime_demo_app/widgets/test_id.dart';

/// The semantics node published by the [TestId] wrapping [key]'s widget.
SemanticsNode _nodeFor(WidgetTester tester, Key key) => tester.getSemantics(
      find.ancestor(of: find.byKey(key), matching: find.byType(TestId)),
    );

void main() {
  group('TestId', () {
    testWidgets('publishes the Flutter key as a native accessibility id',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // identifier -> accessibilityIdentifier (iOS) / resource-id (Android)
      // label      -> content-desc (Android), so one locator serves both.
      for (final entry in {
        TestKeys.loginUsernameField: 'login_username_field',
        TestKeys.loginPasswordField: 'login_password_field',
        TestKeys.loginButton: 'login_button',
        TestKeys.loginCredentialsHint: 'login_credentials_hint',
      }.entries) {
        final node = _nodeFor(tester, entry.key);
        expect(node.identifier, entry.value,
            reason: 'identifier for ${entry.value}');
        // The label merges with the child's own semantics, so the id leads it.
        expect(node.label.split('\n').first, entry.value,
            reason: 'label for ${entry.value}');
      }

      handle.dispose();
    });

    testWidgets('derives the id from the key, so the two cannot drift',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: TestId(
            Key('some_widget_id'),
            child: Text('hi', key: Key('some_widget_id')),
          ),
        ),
      );

      final node = _nodeFor(tester, const Key('some_widget_id'));
      expect(node.identifier, 'some_widget_id');
      handle.dispose();
    });
  });
}

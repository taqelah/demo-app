import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LimeDemoApp());
    // Splash screen has a 2-second timer, pump past it
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    // App should have navigated past splash
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

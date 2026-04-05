import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LimeDemoApp());
    expect(find.text('DemoApp'), findsOneWidget);
  });
}

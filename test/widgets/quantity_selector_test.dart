import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/test_keys.dart';
import 'package:lime_demo_app/widgets/quantity_selector.dart';

void main() {
  group('QuantitySelector', () {
    testWidgets('should display quantity', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuantitySelector(
            quantity: 3,
            onIncrement: () {},
            onDecrement: () {},
          ),
        ),
      ));

      expect(find.byKey(TestKeys.quantityValueText), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should call onIncrement when plus tapped', (tester) async {
      var incremented = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuantitySelector(
            quantity: 1,
            onIncrement: () => incremented = true,
            onDecrement: () {},
          ),
        ),
      ));

      await tester.tap(find.byKey(TestKeys.quantityIncrementButton));
      expect(incremented, true);
    });

    testWidgets('should call onDecrement when minus tapped', (tester) async {
      var decremented = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuantitySelector(
            quantity: 3,
            onIncrement: () {},
            onDecrement: () => decremented = true,
          ),
        ),
      ));

      await tester.tap(find.byKey(TestKeys.quantityDecrementButton));
      expect(decremented, true);
    });

    testWidgets('decrement should be disabled at quantity 1', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuantitySelector(
            quantity: 1,
            onIncrement: () {},
            onDecrement: () {},
          ),
        ),
      ));

      final button = tester.widget<IconButton>(
        find.byKey(TestKeys.quantityDecrementButton),
      );
      expect(button.onPressed, isNull);
    });
  });
}

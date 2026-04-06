import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/models/product.dart';
import 'package:lime_demo_app/widgets/product_card.dart';

const _testProduct = Product(
  id: 1,
  name: 'Test Dress',
  description: 'A beautiful test dress',
  price: 89.99,
  iconCodePoint: 0xea0b,
  colorValue: 0xFFE91E63,
  category: 'Casual',
);

void main() {
  group('ProductCard', () {
    testWidgets('should display product name and price', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 300,
            width: 200,
            child: ProductCard(
              product: _testProduct,
              onTap: () {},
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Test Dress'), findsOneWidget);
      expect(find.text('\$89.99'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 300,
            width: 200,
            child: ProductCard(
              product: _testProduct,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Dress'));
      expect(tapped, true);
    });

    testWidgets('should show add to cart button when provided',
        (tester) async {
      var addedToCart = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 300,
            width: 200,
            child: ProductCard(
              product: _testProduct,
              onTap: () {},
              onAddToCart: () => addedToCart = true,
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final cartIcon = find.byIcon(Icons.add_shopping_cart);
      expect(cartIcon, findsOneWidget);
      await tester.tap(cartIcon);
      expect(addedToCart, true);
    });

    testWidgets('should not show add to cart when not provided',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 300,
            width: 200,
            child: ProductCard(
              product: _testProduct,
              onTap: () {},
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_shopping_cart), findsNothing);
    });
  });
}

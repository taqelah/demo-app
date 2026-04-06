import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/models/product.dart';
import 'package:lime_demo_app/models/cart_item.dart';

void main() {
  group('CartItem', () {
    const product = Product(
      id: 1,
      name: 'Test Dress',
      description: 'A test dress',
      price: 49.99,
      iconCodePoint: 0xea0b,
      colorValue: 0xFFE91E63,
      availableColors: [0xFFE91E63, 0xFF9C27B0],
      imageAsset: 'test.jpg',
      category: 'Casual',
    );

    test('should create with default quantity of 1', () {
      final item = CartItem(
        product: product,
        selectedColor: 0xFFE91E63,
      );
      expect(item.quantity, 1);
      expect(item.selectedColor, 0xFFE91E63);
    });

    test('totalPrice should be price * quantity', () {
      final item = CartItem(
        product: product,
        quantity: 3,
        selectedColor: 0xFFE91E63,
      );
      expect(item.totalPrice, closeTo(149.97, 0.01));
    });

    test('totalPrice should update when quantity changes', () {
      final item = CartItem(
        product: product,
        quantity: 1,
        selectedColor: 0xFFE91E63,
      );
      expect(item.totalPrice, 49.99);
      item.quantity = 5;
      expect(item.totalPrice, closeTo(249.95, 0.01));
    });

    test('toJson should serialize correctly', () {
      final item = CartItem(
        product: product,
        quantity: 2,
        selectedColor: 0xFF9C27B0,
      );
      final json = item.toJson();
      expect(json['quantity'], 2);
      expect(json['selectedColor'], 0xFF9C27B0);
      expect(json['product']['name'], 'Test Dress');
    });

    test('fromJson should deserialize correctly', () {
      final item = CartItem(
        product: product,
        quantity: 2,
        selectedColor: 0xFF9C27B0,
      );
      final json = item.toJson();
      final restored = CartItem.fromJson(json);
      expect(restored.quantity, 2);
      expect(restored.selectedColor, 0xFF9C27B0);
      expect(restored.product.name, 'Test Dress');
      expect(restored.product.price, 49.99);
    });

    test('toJson/fromJson roundtrip should preserve data', () {
      final item = CartItem(
        product: product,
        quantity: 4,
        selectedColor: 0xFFE91E63,
      );
      final restored = CartItem.fromJson(item.toJson());
      expect(restored.quantity, item.quantity);
      expect(restored.selectedColor, item.selectedColor);
      expect(restored.totalPrice, item.totalPrice);
      expect(restored.product.id, item.product.id);
    });
  });
}

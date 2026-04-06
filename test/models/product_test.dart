import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/models/product.dart';

void main() {
  group('Product', () {
    const product = Product(
      id: 1,
      name: 'Test Dress',
      description: 'A beautiful test dress',
      price: 99.99,
      iconCodePoint: 0xea0b,
      colorValue: 0xFFE91E63,
      availableColors: [0xFFE91E63, 0xFF9C27B0],
      imageAsset: 'assets/images/products/test.jpg',
      category: 'Casual',
    );

    test('should create product with all fields', () {
      expect(product.id, 1);
      expect(product.name, 'Test Dress');
      expect(product.description, 'A beautiful test dress');
      expect(product.price, 99.99);
      expect(product.imageAsset, 'assets/images/products/test.jpg');
      expect(product.category, 'Casual');
      expect(product.availableColors.length, 2);
    });

    test('should have default values', () {
      const minimal = Product(
        id: 2,
        name: 'Minimal',
        description: 'Desc',
        price: 10.0,
        iconCodePoint: 0xea0b,
        colorValue: 0xFF000000,
      );
      expect(minimal.imageAsset, '');
      expect(minimal.category, '');
      expect(minimal.availableColors, [0xFF000000, 0xFF1565C0, 0xFFC62828]);
    });

    test('toJson should serialize all fields', () {
      final json = product.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'Test Dress');
      expect(json['price'], 99.99);
      expect(json['imageAsset'], 'assets/images/products/test.jpg');
      expect(json['category'], 'Casual');
      expect(json['availableColors'], [0xFFE91E63, 0xFF9C27B0]);
    });

    test('fromJson should deserialize all fields', () {
      final json = product.toJson();
      final restored = Product.fromJson(json);
      expect(restored.id, product.id);
      expect(restored.name, product.name);
      expect(restored.price, product.price);
      expect(restored.imageAsset, product.imageAsset);
      expect(restored.category, product.category);
      expect(restored.availableColors, product.availableColors);
    });

    test('fromJson should handle missing optional fields', () {
      final json = {
        'id': 3,
        'name': 'Old Product',
        'description': 'Desc',
        'price': 50.0,
        'iconCodePoint': 0xea0b,
        'colorValue': 0xFF000000,
        'availableColors': [0xFF000000],
      };
      final p = Product.fromJson(json);
      expect(p.imageAsset, '');
      expect(p.category, '');
    });

    test('toJson/fromJson roundtrip should preserve data', () {
      final json = product.toJson();
      final restored = Product.fromJson(json);
      final json2 = restored.toJson();
      expect(json, json2);
    });
  });
}

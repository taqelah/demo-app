import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('should have valid credentials', () {
      expect(AppConstants.validUsername, 'emma@demoapp.com');
      expect(AppConstants.validPassword, '10203040');
    });

    test('should have 4 categories', () {
      expect(AppConstants.categories.length, 4);
      expect(AppConstants.categories, ['Casual', 'Evening', 'Party', 'Boho']);
    });

    test('should have 32 products', () {
      expect(AppConstants.products.length, 32);
    });

    test('should have 8 products per category', () {
      for (final category in AppConstants.categories) {
        final count = AppConstants.products
            .where((p) => p.category == category)
            .length;
        expect(count, 8, reason: '$category should have 8 products');
      }
    });

    test('all products should have unique IDs', () {
      final ids = AppConstants.products.map((p) => p.id).toSet();
      expect(ids.length, AppConstants.products.length);
    });

    test('all products should have image assets', () {
      for (final product in AppConstants.products) {
        expect(product.imageAsset.isNotEmpty, true,
            reason: '${product.name} should have an image');
      }
    });

    test('all products should have valid prices', () {
      for (final product in AppConstants.products) {
        expect(product.price > 0, true,
            reason: '${product.name} should have a positive price');
      }
    });

    test('all products should have at least one color', () {
      for (final product in AppConstants.products) {
        expect(product.availableColors.isNotEmpty, true,
            reason: '${product.name} should have colors');
      }
    });

    test('all products should belong to a valid category', () {
      for (final product in AppConstants.products) {
        expect(AppConstants.categories.contains(product.category), true,
            reason: '${product.name} has invalid category: ${product.category}');
      }
    });

    test('pageSize should be 6', () {
      expect(AppConstants.pageSize, 6);
    });
  });
}

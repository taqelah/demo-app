import 'package:flutter_test/flutter_test.dart';
import 'package:lime_demo_app/models/checkout_info.dart';

void main() {
  group('CheckoutInfo', () {
    test('should create with default empty values', () {
      final info = CheckoutInfo();
      expect(info.fullName, '');
      expect(info.addressLine1, '');
      expect(info.addressLine2, '');
      expect(info.city, '');
      expect(info.state, '');
      expect(info.zipCode, '');
      expect(info.country, '');
    });

    test('should create with provided values', () {
      final info = CheckoutInfo(
        fullName: 'Jane Doe',
        addressLine1: '123 Main St',
        addressLine2: 'Apt 4B',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
      );
      expect(info.fullName, 'Jane Doe');
      expect(info.addressLine1, '123 Main St');
      expect(info.addressLine2, 'Apt 4B');
      expect(info.city, 'New York');
      expect(info.state, 'NY');
      expect(info.zipCode, '10001');
      expect(info.country, 'USA');
    });

    test('should allow modifying fields', () {
      final info = CheckoutInfo();
      info.fullName = 'Updated Name';
      info.city = 'Singapore';
      expect(info.fullName, 'Updated Name');
      expect(info.city, 'Singapore');
    });
  });
}

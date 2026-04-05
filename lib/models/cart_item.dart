import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  int selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'selectedColor': selectedColor,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
        selectedColor: json['selectedColor'] as int,
      );
}

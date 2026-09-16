import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import 'test_id.dart';

class CartBadge extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;

  const CartBadge({
    super.key,
    required this.itemCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TestId(
          TestKeys.cartBadgeIcon,
          child: IconButton(
            key: TestKeys.cartBadgeIcon,
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: onPressed,
          ),
        ),
        if (itemCount > 0)
          Positioned(
            top: 4,
            right: 4,
            child: TestId(
                     TestKeys.cartBadgeCount,
                     child: Container(
              key: TestKeys.cartBadgeCount,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '$itemCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
                   ),
          ),
      ],
    );
  }
}

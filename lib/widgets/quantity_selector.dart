import 'package:flutter/material.dart';
import '../constants/test_keys.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: TestKeys.quantityDecrementButton,
          onPressed: quantity > 1 ? onDecrement : null,
          icon: const Icon(Icons.remove_circle_outline),
          iconSize: 28,
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$quantity',
            key: TestKeys.quantityValueText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
          key: TestKeys.quantityIncrementButton,
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline),
          iconSize: 28,
        ),
      ],
    );
  }
}

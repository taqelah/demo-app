import 'package:flutter/material.dart';
import '../constants/test_keys.dart';

enum SortOption {
  nameAsc('Name (A-Z)'),
  nameDesc('Name (Z-A)'),
  priceAsc('Price (Low-High)'),
  priceDesc('Price (High-Low)');

  final String label;
  const SortOption(this.label);
}

const _sortKeyMap = {
  SortOption.nameAsc: TestKeys.sortOptionNameAsc,
  SortOption.nameDesc: TestKeys.sortOptionNameDesc,
  SortOption.priceAsc: TestKeys.sortOptionPriceAsc,
  SortOption.priceDesc: TestKeys.sortOptionPriceDesc,
};

class SortDialog extends StatelessWidget {
  final SortOption currentSort;

  const SortDialog({super.key, required this.currentSort});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Sort By',
            key: TestKeys.sortDialogTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const Divider(height: 1),
        ...SortOption.values.map(
          (option) => ListTile(
            key: _sortKeyMap[option],
            title: Text(option.label),
            trailing: currentSort == option
                ? Icon(Icons.check,
                    color: Theme.of(context).colorScheme.primary)
                : null,
            onTap: () => Navigator.pop(context, option),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

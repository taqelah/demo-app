import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/local_storage_service.dart';
import '../widgets/quantity_selector.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  late int _selectedColor;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final product = ModalRoute.of(context)!.settings.arguments as Product;
      _selectedColor = product.availableColors.first;
      _initialized = true;
    }
  }

  Future<void> _addToCart(Product product) async {
    final cartItems = await LocalStorageService.loadCart();

    final existingIndex = cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == _selectedColor,
    );

    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += _quantity;
    } else {
      cartItems.add(CartItem(
        product: product,
        quantity: _quantity,
        selectedColor: _selectedColor,
      ));
    }

    await LocalStorageService.saveCart(cartItems);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              key: TestKeys.detailImage,
              width: double.infinity,
              height: 350,
              child: product.imageAsset.isNotEmpty
                  ? Image.asset(
                      product.imageAsset,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Color(product.colorValue).withValues(alpha: 0.15),
                      child: Center(
                        child: Icon(
                          IconData(product.iconCodePoint,
                              fontFamily: 'MaterialIcons'),
                          size: 120,
                          color: Color(product.colorValue),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    key: TestKeys.detailName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    key: TestKeys.detailPrice,
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    key: TestKeys.detailDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Color',
                    key: TestKeys.detailColorLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: product.availableColors
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final colorValue = entry.value;
                      final isSelected = colorValue == _selectedColor;
                      return GestureDetector(
                        key: TestKeys.detailColorOption(index),
                        onTap: () {
                          setState(() => _selectedColor = colorValue);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(colorValue),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 3,
                                  )
                                : Border.all(
                                    color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quantity',
                    key: TestKeys.detailQuantityLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  QuantitySelector(
                    quantity: _quantity,
                    onIncrement: () => setState(() => _quantity++),
                    onDecrement: () => setState(() => _quantity--),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    key: TestKeys.detailAddToCartButton,
                    onPressed: () => _addToCart(product),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

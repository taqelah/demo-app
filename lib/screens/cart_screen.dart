import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../models/cart_item.dart';
import '../services/local_storage_service.dart';
import '../widgets/quantity_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await LocalStorageService.loadCart();
    if (mounted) {
      setState(() => _cartItems = items);
    }
  }

  Future<void> _updateCart() async {
    await LocalStorageService.saveCart(_cartItems);
  }

  double get _totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  void _removeItem(int index) {
    setState(() => _cartItems.removeAt(index));
    _updateCart();
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity < 1) return;
    setState(() => _cartItems[index].quantity = newQuantity);
    _updateCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    key: TestKeys.cartEmptyIcon,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    key: TestKeys.cartEmptyText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    key: TestKeys.cartContinueShoppingButton,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    key: TestKeys.cartItemsList,
                    padding: const EdgeInsets.all(8),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Dismissible(
                        key: TestKeys.cartItemDismissible(item.product.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 32),
                        ),
                        onDismissed: (_) => _removeItem(index),
                        child: Card(
                          key: TestKeys.cartItem(index),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: item.product.imageAsset.isNotEmpty
                                        ? Image.asset(
                                            item.product.imageAsset,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Color(item.product.colorValue)
                                                .withValues(alpha: 0.15),
                                            child: Icon(
                                              IconData(item.product.iconCodePoint,
                                                  fontFamily: 'MaterialIcons'),
                                              color: Color(item.product.colorValue),
                                              size: 32,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${item.totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          QuantitySelector(
                                            quantity: item.quantity,
                                            onIncrement: () =>
                                                _updateQuantity(
                                                    index, item.quantity + 1),
                                            onDecrement: () =>
                                                _updateQuantity(
                                                    index, item.quantity - 1),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            key: TestKeys.cartItemDelete(index),
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _removeItem(index),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${_totalPrice.toStringAsFixed(2)}',
                            key: TestKeys.cartTotalText,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        key: TestKeys.cartCheckoutButton,
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout-info');
                        },
                        child: const Text('Proceed to Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

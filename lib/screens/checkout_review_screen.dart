import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../models/checkout_info.dart';
import '../models/cart_item.dart';
import '../services/local_storage_service.dart';

class CheckoutReviewScreen extends StatefulWidget {
  const CheckoutReviewScreen({super.key});

  @override
  State<CheckoutReviewScreen> createState() => _CheckoutReviewScreenState();
}

class _CheckoutReviewScreenState extends State<CheckoutReviewScreen> {
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

  double get _totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  Future<void> _placeOrder() async {
    await LocalStorageService.clearCart();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, '/checkout-complete', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final info = ModalRoute.of(context)!.settings.arguments as CheckoutInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Address',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              key: TestKeys.reviewShippingCard,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(info.addressLine1),
                    if (info.addressLine2.isNotEmpty) Text(info.addressLine2),
                    Text('${info.city}, ${info.state} ${info.zipCode}'),
                    Text(info.country),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ..._cartItems.asMap().entries.map(
                  (entry) => Card(
                    key: TestKeys.reviewOrderItem(entry.key),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(entry.value.product.colorValue)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          IconData(entry.value.product.iconCodePoint,
                              fontFamily: 'MaterialIcons'),
                          color: Color(entry.value.product.colorValue),
                          size: 24,
                        ),
                      ),
                      title: Text(entry.value.product.name),
                      subtitle: Text('Qty: ${entry.value.quantity}'),
                      trailing: Text(
                        '\$${entry.value.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '\$${_totalPrice.toStringAsFixed(2)}',
                  key: TestKeys.reviewTotalText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: TestKeys.reviewPlaceOrderButton,
              onPressed: _placeOrder,
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

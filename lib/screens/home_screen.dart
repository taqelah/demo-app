import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/test_keys.dart';
import '../models/cart_item.dart';
import '../services/local_storage_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_badge.dart';

class _CategoryInfo {
  final String name;
  final String subtitle;
  final IconData icon;
  final int colorValue;
  final String imageAsset;

  const _CategoryInfo({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.colorValue,
    required this.imageAsset,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CartItem> _cartItems = [];

  static const _categoryDetails = [
    _CategoryInfo(
      name: 'Casual',
      subtitle: 'Everyday comfort & style',
      icon: Icons.wb_sunny,
      colorValue: 0xFF42A5F5,
      imageAsset: 'assets/images/products/casual_sundress.jpg',
    ),
    _CategoryInfo(
      name: 'Evening',
      subtitle: 'Elegant gowns & formal wear',
      icon: Icons.nightlife,
      colorValue: 0xFF7B1FA2,
      imageAsset: 'assets/images/products/satin_evening_gown.jpg',
    ),
    _CategoryInfo(
      name: 'Party',
      subtitle: 'Cocktail & party dresses',
      icon: Icons.celebration,
      colorValue: 0xFFAD1457,
      imageAsset: 'assets/images/products/lace_cocktail_dress.jpg',
    ),
    _CategoryInfo(
      name: 'Boho',
      subtitle: 'Free-spirited & artistic',
      icon: Icons.eco,
      colorValue: 0xFFFF7043,
      imageAsset: 'assets/images/products/boho_wrap_dress.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await LocalStorageService.loadCart();
    if (mounted) setState(() => _cartItems = items);
  }

  int get _totalCartItems =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DemoApp'),
        actions: [
          CartBadge(
            key: TestKeys.catalogCartBadge,
            itemCount: _totalCartItems,
            onPressed: () {
              Navigator.pushNamed(context, '/cart').then((_) => _loadCart());
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/products/floral_maxi_dress.jpg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Collection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Explore the latest trends in women\'s fashion',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/catalog')
                              .then((_) => _loadCart());
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(140, 40),
                        ),
                        child: const Text('Shop All'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Categories header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shop by Category',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/catalog')
                      .then((_) => _loadCart());
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category cards
          ..._categoryDetails.map((cat) {
            final count = AppConstants.products
                .where((p) => p.category == cat.name)
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/catalog',
                          arguments: cat.name)
                      .then((_) => _loadCart());
                },
                borderRadius: BorderRadius.circular(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          cat.imageAsset,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(cat.colorValue).withValues(alpha: 0.85),
                                Color(cat.colorValue).withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(cat.icon, color: Colors.white, size: 40),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      cat.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cat.subtitle,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$count items',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white70, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

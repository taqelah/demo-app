import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/test_keys.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/local_storage_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_card.dart';
import '../widgets/sort_dialog.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  late List<Product> _allProducts;
  List<Product> _displayedProducts = [];
  List<CartItem> _cartItems = [];
  SortOption _currentSort = SortOption.nameAsc;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _categoryFilter;
  bool _initialized = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _categoryFilter =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (_categoryFilter != null) {
        _allProducts = AppConstants.products
            .where((p) => p.category == _categoryFilter)
            .toList();
      } else {
        _allProducts = List.from(AppConstants.products);
      }
      _sortProducts();
      _loadInitialPage();
      _loadCart();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialPage() {
    final source = _filteredAllProducts;
    final end = AppConstants.pageSize.clamp(0, source.length);
    _displayedProducts = source.sublist(0, end);
    _hasMore = end < source.length;
  }

  void _loadMoreProducts() {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);

    // Simulate network delay for realistic lazy loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final source = _filteredAllProducts;
      final currentLength = _displayedProducts.length;
      final end =
          (currentLength + AppConstants.pageSize).clamp(0, source.length);

      setState(() {
        _displayedProducts = source.sublist(0, end);
        _hasMore = end < source.length;
        _isLoadingMore = false;
      });
    });
  }

  Future<void> _loadCart() async {
    final items = await LocalStorageService.loadCart();
    if (mounted) {
      setState(() => _cartItems = items);
    }
  }

  void _sortProducts() {
    switch (_currentSort) {
      case SortOption.nameAsc:
        _allProducts.sort((a, b) => a.name.compareTo(b.name));
      case SortOption.nameDesc:
        _allProducts.sort((a, b) => b.name.compareTo(a.name));
      case SortOption.priceAsc:
        _allProducts.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        _allProducts.sort((a, b) => b.price.compareTo(a.price));
    }
  }

  Future<void> _showSortDialog() async {
    final result = await showModalBottomSheet<SortOption>(
      context: context,
      builder: (context) => SortDialog(currentSort: _currentSort),
    );
    if (result != null) {
      _currentSort = result;
      _sortProducts();
      setState(() {
        _loadInitialPage();
      });
    }
  }

  List<Product> get _filteredAllProducts {
    if (_searchQuery.isEmpty) return _allProducts;
    return _allProducts
        .where(
            (p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _loadInitialPage();
    });
  }

  int get _totalCartItems =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    final title =
        _categoryFilter != null ? '$_categoryFilter Dresses' : 'All Dresses';
    final totalCount = _filteredAllProducts.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            key: TestKeys.catalogSortButton,
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
          CartBadge(
            key: TestKeys.catalogCartBadge,
            itemCount: _totalCartItems,
            onPressed: () {
              Navigator.pushNamed(context, '/cart').then((_) => _loadCart());
            },
          ),
        ],
      ),
      drawer: _categoryFilter == null ? const AppDrawer() : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              key: TestKeys.catalogSearchBar,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search dresses...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        key: TestKeys.catalogSearchClear,
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Text(
                  'Showing ${_displayedProducts.length} of $totalCount items',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _displayedProducts.isEmpty && !_isLoadingMore
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('No dresses found',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification &&
                          notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 200) {
                        _loadMoreProducts();
                      }
                      return false;
                    },
                    child: GridView.builder(
                      key: TestKeys.catalogGrid,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _displayedProducts.length,
                      itemBuilder: (context, index) {
                        final product = _displayedProducts[index];
                        return ProductCard(
                          key: TestKeys.catalogProductCard(product.id),
                          product: product,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product-detail',
                              arguments: product,
                            ).then((_) => _loadCart());
                          },
                        );
                      },
                    ),
                  ),
          ),
          if (_isLoadingMore)
            Container(
              padding: const EdgeInsets.all(12),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

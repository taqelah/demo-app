import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  /// BUG: when true the price is painted below the tile's bottom edge instead
  /// of inside it. Set for search results only - see ProductCatalogScreen.
  final bool priceEscapesTile;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
    this.priceEscapesTile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // The card normally clips its children, which would slice the shifted
      // price off rather than let it hang outside.
      clipBehavior: priceEscapesTile ? Clip.none : Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                // Keeps the rounded top corners even when the card itself is
                // not clipping.
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.imageAsset.isNotEmpty
                    ? Image.asset(
                        product.imageAsset,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color:
                            Color(product.colorValue).withValues(alpha: 0.15),
                        child: Center(
                          child: Icon(
                            IconData(product.iconCodePoint,
                                fontFamily: 'MaterialIcons'),
                            size: 64,
                            color: Color(product.colorValue),
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Transform.translate(
                          // Paints without re-laying out, so nothing reflows
                          // and no overflow banner fires - the price simply
                          // ends up past the bottom edge of the tile.
                          offset: Offset(0, priceEscapesTile ? 14 : 0),
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onAddToCart != null)
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        onPressed: onAddToCart,
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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

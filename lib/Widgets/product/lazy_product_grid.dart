import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/product/product_card.dart';
import 'package:imat_repo/model/imat/product.dart';

/// Shared grid layout for product browse pages (matches [AllProductsPage]).
const productGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  crossAxisSpacing: 24,
  mainAxisSpacing: 24,
  // Fixed row height: card content is ~356px; width varies per column.
  mainAxisExtent: 380,
);

/// Lazy-built product grid as a sliver for [CustomScrollView].
Widget lazyProductGridSliver(List<Product> products) {
  if (products.isEmpty) {
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  return SliverGrid(
    gridDelegate: productGridDelegate,
    delegate: SliverChildBuilderDelegate(
      (context, index) => Align(
        alignment: Alignment.topCenter,
        child: ProductCard(product: products[index]),
      ),
      childCount: products.length,
    ),
  );
}

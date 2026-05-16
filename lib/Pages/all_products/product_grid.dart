import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/product_card.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/imat/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Text(
        "Inga produkter matchar filtret.",
        style: IMatText.bodyM,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth > 1400
            ? 260
            : constraints.maxWidth > 1100
                ? 230
                : constraints.maxWidth > 800
                    ? 200
                    : 160;

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: products.map((p) {
            return SizedBox(
              width: cardWidth,
              child: ProductCard(product: p),
            );
          }).toList(),
        );
      },
    );
  }
}

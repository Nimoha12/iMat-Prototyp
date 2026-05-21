import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/product_card.dart';
import 'package:imat_repo/Pages/all_products/ui_categories.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/imat/product.dart';

class CategorizedProductSections extends StatelessWidget {
  final Map<UiCategory, List<Product>> productsByCategory;
  final void Function(UiCategory) onCategoryHeaderTap;

  const CategorizedProductSections({
    super.key,
    required this.productsByCategory,
    required this.onCategoryHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: productsByCategory.entries.map((entry) {
        if (entry.value.isEmpty) return SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => onCategoryHeaderTap(entry.key),
                child: Text(
                  entry.key.label,
                  style: IMatText.h3.copyWith(
                    color: IMatColors.green,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: entry.value.map((product) {
                  return SizedBox(
                    width: 260,
                    child: ProductCard(product: product),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

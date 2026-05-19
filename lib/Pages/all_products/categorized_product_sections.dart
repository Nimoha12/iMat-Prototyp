import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/product_card.dart';
import 'package:imat_repo/Pages/all_products/ui_categories.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/imat/product.dart';

class CategorizedProductSections extends StatelessWidget {
  final Map<UiCategory, List<Product>> productsByCategory;
  final Map<UiCategory, GlobalKey> sectionKeys;

  const CategorizedProductSections({
    super.key,
    required this.productsByCategory,
    required this.sectionKeys,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: productsByCategory.keys.map((uiCategory) {
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                final context = sectionKeys[uiCategory]!.currentContext;

                if (context == null) {
                  return;
                }

                Scrollable.ensureVisible(
                  context,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: IMatColors.greenLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: IMatColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  child: Text(
                    uiCategory.label,
                    style: IMatText.bodyM.copyWith(
                      fontWeight: FontWeight.w700,
                      color: IMatColors.green,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        ...productsByCategory.entries.map((entry) {
          return Padding(
            key: sectionKeys[entry.key],
            padding: const EdgeInsets.only(bottom: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key.label, style: IMatText.h3),
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
        }),
      ],
    );
  }
}

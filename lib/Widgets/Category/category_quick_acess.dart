import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/recommended_products.dart';
import 'ui_categories.dart';

class CategoryQuickAccessGrid extends StatelessWidget {
  final void Function(UiCategory) onCategoryTap;
  final VoidCallback? onRecommendedTap;

  const CategoryQuickAccessGrid({
    super.key,
    required this.onCategoryTap,
    this.onRecommendedTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth > 1200
            ? 220
            : constraints.maxWidth > 900
                ? 200
                : 170;

        Widget categoryButton(String label, VoidCallback onTap) {
          return SizedBox(
            width: cardWidth,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Ink(
                decoration: BoxDecoration(
                  color: IMatColors.green,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: IMatColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: IMatText.bodyM.copyWith(
                        fontWeight: FontWeight.w700,
                        color: IMatColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ...UiCategory.values.map(
              (uiCat) => categoryButton(uiCat.label, () => onCategoryTap(uiCat)),
            ),
            if (onRecommendedTap != null)
              categoryButton(recommendedProductsTitle, onRecommendedTap!),
          ],
        );
      },
    );
  }
}

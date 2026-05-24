import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'ui_categories.dart';

class CategoryQuickAccessGrid extends StatelessWidget {
  final void Function(UiCategory) onCategoryTap;

  const CategoryQuickAccessGrid({
    super.key,
    required this.onCategoryTap,
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

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: UiCategory.values.map((uiCat) {
            return SizedBox(
              width: cardWidth,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onCategoryTap(uiCat),
                child: Ink(
                  decoration: BoxDecoration(
                    // konsekvent färg och stil
                    color: IMatColors.green,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: IMatColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    child: Center(
                      child: Text(
                        uiCat.label,
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
          }).toList(),
        );
      },
    );
  }
}

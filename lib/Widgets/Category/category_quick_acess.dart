import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/recommended_products.dart';
import 'ui_categories.dart';

const int categoryQuickAccessMaxButtonsPerRow = 4;
const double _categoryQuickAccessSpacing = 16;

double categoryQuickAccessCardWidth(double maxWidth) {
  if (maxWidth > 1200) return 220;
  if (maxWidth > 900) return 200;
  return 170;
}

Widget categoryQuickAccessButtonRows(List<Widget> buttons) {
  if (buttons.isEmpty) return const SizedBox.shrink();

  final rows = <Widget>[];
  for (var start = 0; start < buttons.length; start += categoryQuickAccessMaxButtonsPerRow) {
    final end = start + categoryQuickAccessMaxButtonsPerRow;
    rows.add(
      Wrap(
        spacing: _categoryQuickAccessSpacing,
        children: buttons.sublist(
          start,
          end > buttons.length ? buttons.length : end,
        ),
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      rows.first,
      for (var i = 1; i < rows.length; i++)
        Padding(
          padding: const EdgeInsets.only(top: _categoryQuickAccessSpacing),
          child: rows[i],
        ),
    ],
  );
}

class CategoryQuickAccessButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double width;

  const CategoryQuickAccessButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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
}

/// Green category chips with fixed width — same layout as [CategoryQuickAccessGrid].
class CategoryQuickAccessButtonWrap extends StatelessWidget {
  final List<String> labels;
  final void Function(int index) onTap;

  const CategoryQuickAccessButtonWrap({
    super.key,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = categoryQuickAccessCardWidth(constraints.maxWidth);

        return categoryQuickAccessButtonRows([
          for (var i = 0; i < labels.length; i++)
            CategoryQuickAccessButton(
              label: labels[i],
              width: cardWidth,
              onTap: () => onTap(i),
            ),
        ]);
      },
    );
  }
}

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
        final cardWidth = categoryQuickAccessCardWidth(constraints.maxWidth);

        return categoryQuickAccessButtonRows([
          ...UiCategory.values.map(
            (uiCat) => CategoryQuickAccessButton(
              label: uiCat.label,
              width: cardWidth,
              onTap: () => onCategoryTap(uiCat),
            ),
          ),
          if (onRecommendedTap != null)
            CategoryQuickAccessButton(
              label: recommendedProductsTitle,
              width: cardWidth,
              onTap: onRecommendedTap!,
            ),
        ]);
      },
    );
  }
}

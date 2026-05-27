import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/model/imat/product.dart';

class CategorizedProductSections extends StatelessWidget {
  final Map<UiCategory, List<Product>> productsByCategory;
  final void Function(UiCategory) onCategoryHeaderTap;

  const CategorizedProductSections({
    super.key,
    required this.productsByCategory,
    required this.onCategoryHeaderTap,
  });

  List<Widget> buildSlivers() {
    final slivers = <Widget>[];

    for (final entry in productsByCategory.entries) {
      if (entry.value.isEmpty) continue;

      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () => onCategoryHeaderTap(entry.key),
              child: Text(
                entry.key.label,
                style: IMatText.h3.copyWith(
                  color: IMatColors.green,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      );
      slivers.add(lazyProductGridSliver(entry.value));
      slivers.add(const SliverPadding(padding: EdgeInsets.only(bottom: 32)));
    }

    return slivers;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: buildSlivers());
  }
}

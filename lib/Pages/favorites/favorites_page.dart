import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/category_page.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/Widgets/Category/categorized_product_sections.dart';
import 'package:imat_repo/Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat_data_handler.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ScrollController scrollController = ScrollController();
  final Map<UiCategory, GlobalKey> sectionKeys = {};

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final favorites = iMat.favorites;

    final favoriteProductsByCategory = <UiCategory, List<Product>>{};

    for (final uiCategory in UiCategory.values) {
      sectionKeys.putIfAbsent(uiCategory, GlobalKey.new);

      final categories = categoryMap[uiCategory] ?? [];
      final categoryFavorites = favorites
          .where((p) => categories.contains(p.category))
          .toList();

      if (categoryFavorites.isNotEmpty) {
        favoriteProductsByCategory[uiCategory] = categoryFavorites;
      }
    }

    return IMatScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Hem",
                      style: IMatText.bodyL.copyWith(
                        color: IMatColors.green,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.chevron_right, size: 24),
                  ),
                  Text(
                    "Favoriter",
                    style: IMatText.bodyL.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text("Favoriter", style: IMatText.h2),

              const SizedBox(height: 24),

              if (favorites.isEmpty)
                Text(
                  "Du har inga favoritvaror än.",
                  style: IMatText.bodyM.copyWith(
                    color: IMatColors.textSecondary,
                  ),
                )
              else
                CategorizedProductSections(
                  productsByCategory: favoriteProductsByCategory,
                  onCategoryHeaderTap: (uiCat){
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (_) => CategoryPage(uiCategory: uiCat))
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/Pages/all_products/product_card.dart';
import 'package:imat_repo/Pages/all_products/ui_categories.dart';
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

              if (favorites.isNotEmpty) ...[
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: favoriteProductsByCategory.keys.map((uiCategory) {
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
              ],

              if (favorites.isEmpty)
                Text(
                  "Du har inga favoritvaror än.",
                  style: IMatText.bodyM.copyWith(
                    color: IMatColors.textSecondary,
                  ),
                )
              else
                ...favoriteProductsByCategory.entries.map((entry) {
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
          ),
        ),
      ),
    );
  }
}

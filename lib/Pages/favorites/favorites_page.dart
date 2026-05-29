import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/category_page.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/CloseProfile_Button.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat_data_handler.dart';


class FavoritesPage extends StatefulWidget {
  static const routeName = '/favorites';

  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ScrollController scrollController = ScrollController();
  bool showScrollButton = false;


  @override
void initState() {
  super.initState();

  scrollController.addListener(() {
    if (scrollController.offset > 300 && !showScrollButton) {
      setState(() => showScrollButton = true);
    } else if (scrollController.offset <= 300 && showScrollButton) {
      setState(() => showScrollButton = false);
    }
  });
}

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
      final categories = categoryMap[uiCategory] ?? [];
      final categoryFavorites = favorites
          .where((p) => categories.contains(p.category))
          .toList();

      if (categoryFavorites.isNotEmpty) {
        favoriteProductsByCategory[uiCategory] = categoryFavorites;
      }
    }

    final visibleSections = favoriteProductsByCategory.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: const IMatNavbar(activePage: NavbarPage.favorites),
      backgroundColor: IMatColors.beige,
      body: Stack(children: [ Padding(
        // Keep scrollbar at far right while preserving left breathing room.
        padding: const EdgeInsets.only(left: 24),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            if (visibleSections.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryPage(
                                  uiCategory: visibleSections.first.key,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            visibleSections.first.key.label,
                            style: IMatText.h3.copyWith(
                              color: IMatColors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const CloseProfileButton(),
                    ],
                  ),
                ),
                
              ),
            if (favorites.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    right: 16,
                    bottom: 80,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [CloseProfileButton()],
                  ),
                ),
              )
            else ...[
              lazyProductGridSliver(visibleSections.first.value),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              for (final entry in visibleSections.skip(1)) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, right: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryPage(uiCategory: entry.key),
                          ),
                        );
                      },
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
                lazyProductGridSliver(entry.value),
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ],
          ],
        ),
      ),
          if (showScrollButton)
      Positioned(
        right: 24,
        bottom: 24,
        child: FloatingActionButton(
          backgroundColor: IMatColors.green,
          onPressed: () {
            scrollController.jumpTo(0);
          },
          child: const Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
      ),
      ]
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/subCategoryPage.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

import 'ui_categories.dart';
import 'product_card.dart';
import 'product_filter_panel.dart';
import 'all_categories_page.dart';
import 'subcategories.dart';

class CategoryPage extends StatefulWidget {
  final UiCategory uiCategory;

  const CategoryPage({super.key, required this.uiCategory});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";

  bool filterOpen = false;

  final ScrollController scrollController = ScrollController();
  final Map<String, GlobalKey> sectionKeys = {};

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final allProducts = iMat.selectProducts;
    final groups = subCategoryGroups[widget.uiCategory] ?? [];

    for (var g in groups) {
      sectionKeys[g.title] = GlobalKey();
    }

    List<Product> applyFilters(List<Product> products) {
      var list = products;

      if (ecoFilter == EcoFilter.eco) {
        list = list.where((p) => p.isEcological).toList();
      } else if (ecoFilter == EcoFilter.inteEco) {
        list = list.where((p) => !p.isEcological).toList();
      }

      list = list.where((p) => p.price <= maxPrice).toList();

      if (sortBy == "priceAsc") {
        list.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortBy == "priceDesc") {
        list.sort((a, b) => b.price.compareTo(a.price));
      }

      return list;
    }

    return IMatScaffold(
      body: Stack(
        children: [
          // HUVUDINNEHÅLL
          Positioned.fill(
            child: Padding(
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

                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllCategoriesPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Alla varor",
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
                          widget.uiCategory.label,
                          style: IMatText.bodyL.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(widget.uiCategory.label, style: IMatText.h2),

                    const SizedBox(height: 16),

                    // Filter-knapp (optimerad)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => filterOpen = true),
                      icon: Icon(
                        Icons.filter_list,
                        color: IMatColors.green,
                        size: 22,
                      ),
                      label: Text(
                        "Filtrera bland varor",
                        style: IMatText.bodyM.copyWith(
                          fontWeight: FontWeight.w800, // kraftfullare text
                          color: IMatColors.black,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IMatColors.white,
                        foregroundColor: IMatColors.black,
                        elevation: 3, // subtil höjd
                        shadowColor: IMatColors.green.withOpacity(0.25),
                        side: BorderSide(
                          color: IMatColors.green,
                          width: 2,
                        ), // tydlig outline
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: groups.map((g) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubCategoryPage(
                                  title: g.title,
                                  categories: g.categories,
                                ),
                              ),
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
                                g.title,
                                style: IMatText.bodyM.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: IMatColors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    ...groups.map((group) {
                      final subProducts = allProducts
                          .where((p) => group.categories.contains(p.category))
                          .toList();

                      final filtered = applyFilters(subProducts);

                      if (filtered.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        key: sectionKeys[group.title],
                        padding: const EdgeInsets.only(bottom: 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SubCategoryPage(
                                      title: group.title,
                                      categories: group.categories,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                group.title,
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
                              children: filtered.map((product) {
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
          ),

          // OVERLAY
          if (filterOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => filterOpen = false),
                child: AnimatedOpacity(
                  opacity: filterOpen ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(color: Colors.black.withOpacity(0.45)),
                ),
              ),
            ),

          // SLIDE-IN PANEL
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: filterOpen ? 0 : -350,
            top: 0,
            bottom: 0,
            child: ProductFilterPanel(
              fullHeight: true,
              maxPrice: maxPrice,
              onPriceChange: (v) => setState(() => maxPrice = v),
              ecoFilter: ecoFilter,
              onEcoChange: (v) => setState(() => ecoFilter = v),
              sortBy: sortBy,
              onSortChange: (v) => setState(() => sortBy = v),
              selectedCategory: null,
              onCategoryChange: (_) {},
              onClose: () => setState(() => filterOpen = false),
            ),
          ),
        ],
      ),
    );
  }
}

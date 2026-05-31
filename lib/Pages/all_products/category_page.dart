import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Navigation/breadcrumb_bar.dart';
import 'package:imat_repo/Widgets/Navigation/filter_button.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Widgets/product/product_filter_overlay.dart';
import 'package:imat_repo/Widgets/product/product_filter_panel.dart';
import 'package:imat_repo/Pages/all_products/all_categories_page.dart';
import 'package:imat_repo/Pages/all_products/subCategoryPage.dart';
import 'package:imat_repo/Widgets/Category/category_quick_acess.dart';
import 'package:imat_repo/Widgets/Category/subcategories.dart';
import '../../Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/Widgets/product/filter_selection.dart';

import 'package:imat_repo/Widgets/Navigation/scroll_to_top_button.dart';

class CategoryPage extends StatefulWidget {
  final UiCategory uiCategory;

  const CategoryPage({super.key, required this.uiCategory});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ScrollController _scrollController = ScrollController();

  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";
  FilterSelection selection = const FilterSelection();

  void _openFilter(BuildContext context) {
    ProductFilterOverlay.show(
      context,
      maxPrice: maxPrice,
      ecoFilter: ecoFilter,
      sortBy: sortBy,
      selection: selection,
      contextCategory: widget.uiCategory,
      onChanged: ({
        required maxPrice,
        required ecoFilter,
        required sortBy,
        required selection,
      }) {
        setState(() {
          this.maxPrice = maxPrice;
          this.ecoFilter = ecoFilter;
          this.sortBy = sortBy;
          this.selection = selection;
        });
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final allProducts = iMat.selectProducts;
    final groups = subCategoryGroups[widget.uiCategory] ?? [];

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

    final breadcrumbItems = [
      BreadcrumbItem(
        label: "Alla varor",
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AllCategoriesPage()),
          );
        },
      ),
      BreadcrumbItem(label: widget.uiCategory.label),
    ];

    return IMatScaffold(
      breadcrumbContext: breadcrumbItems,
      body: Stack(
        children: [
          // FIX: INGEN Positioned.fill
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: BreadcrumbBar(
                              items: [
                                BreadcrumbItem(
                                  label: "Alla varor",
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AllCategoriesPage(),
                                      ),
                                    );
                                  },
                                ),
                                BreadcrumbItem(label: widget.uiCategory.label),
                              ],
                            ),
                          ),
                          FilterButton(
                            onPressed: () => _openFilter(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(widget.uiCategory.label, style: IMatText.h2),
                      const SizedBox(height: 24),

                      if (groups.isNotEmpty)
                        CategoryQuickAccessButtonWrap(
                          labels: groups.map((g) => g.title).toList(),
                          onTap: (index) {
                            final g = groups[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubCategoryPage(
                                  title: g.title,
                                  categories: g.categories,
                                  parentCategory: widget.uiCategory,
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                if (groups.isEmpty) ...() {
                  final categories = categoryMap[widget.uiCategory] ?? [];
                  final filtered = applyFilters(
                    allProducts
                        .where((p) => categories.contains(p.category))
                        .toList(),
                  );
                  if (filtered.isEmpty) return <Widget>[];

                  return [
                    lazyProductGridSliver(filtered),
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 32),
                    ),
                  ];
                }(),

                for (final group in groups)
                  ...() {
                    if (selection.selectedSubCategories.isNotEmpty &&
                        !selection.selectedSubCategories.contains(group.title)) {
                      return <Widget>[];
                    }

                    final filtered = applyFilters(
                      allProducts
                          .where((p) => group.categories.contains(p.category))
                          .toList(),
                    );
                    if (filtered.isEmpty) return <Widget>[];

                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SubCategoryPage(
                                    title: group.title,
                                    categories: group.categories,
                                    parentCategory: widget.uiCategory,
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
                        ),
                      ),
                      lazyProductGridSliver(filtered),
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 32),
                      ),
                    ];
                  }(),
              ],
            ),
          ),

          // GLOBAL scroll-to-top button
          ScrollToTopButton(controller: _scrollController),
        ],
      ),
    );
  }
}

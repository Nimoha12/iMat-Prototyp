import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Navigation/breadcrumb_bar.dart';
import 'package:imat_repo/Widgets/Navigation/filter_button.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Widgets/product/product_filter_panel.dart';
import 'package:imat_repo/Pages/all_products/all_categories_page.dart';
import 'package:imat_repo/Pages/all_products/subCategoryPage.dart';
import 'package:imat_repo/Widgets/Category/subcategories.dart';
import '../../Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/Widgets/product/filter_selection.dart';

class CategoryPage extends StatefulWidget {
  final UiCategory uiCategory;

  const CategoryPage({super.key, required this.uiCategory});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool showScrollButton = false;

  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";
  bool filterOpen = false;

  FilterSelection selection = const FilterSelection();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !showScrollButton) {
        setState(() => showScrollButton = true);
      } else if (_scrollController.offset <= 300 && showScrollButton) {
        setState(() => showScrollButton = false);
      }
    });
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

    // UX: If this category only has a single subcategory, skip the
    // intermediate node and show the products for the subcategory directly.
    // This prevents the user from having to tap "extra" levels in the tree.
    if (groups.length == 1) {
      final group = groups.first;
      return SubCategoryPage(
        title: group.title,
        categories: group.categories,
        parentCategory: widget.uiCategory,
        showParentBreadcrumb: false,
      );
    }

    // Filtreringsfunktion
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
          // Huvudinnehåll
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BreadcrumbBar(
                          items: [
                            BreadcrumbItem(
                              label: "Alla varor",
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AllCategoriesPage(),
                                  ),
                                );
                              },
                            ),
                            BreadcrumbItem(label: widget.uiCategory.label),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 1396,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.uiCategory.label, style: IMatText.h2),
                              FilterButton(
                                onPressed: () =>
                                    setState(() => filterOpen = true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (groups.isNotEmpty)
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
                                        parentCategory: widget.uiCategory,
                                      ),
                                    ),
                                  );
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: IMatColors.green,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: IMatColors.border,
                                    ),
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
                                        color: IMatColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                  for (final group in groups)
                    ...() {
                      // Multi-select underkategorier: om något är valt, visa bara de valda
                      if (selection.selectedSubCategories.isNotEmpty &&
                          !selection.selectedSubCategories.contains(
                            group.title,
                          )) {
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
          ),

          // Overlay
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

          // Filterpanel
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
              selection: selection,
              onSelectionChanged: (s) => setState(() => selection = s),
              contextCategory: widget.uiCategory,
              onClose: () => setState(() => filterOpen = false),
              onApplyFilters: () {
                setState(() {
                  filterOpen = false;
                });
              },
            ),
          ),

          // Scroll-to-top button
          if (showScrollButton)
            Positioned(
              right: 24,
              bottom: 24,
              child: FloatingActionButton.large(
                backgroundColor: IMatColors.green,
                onPressed: () => _scrollController.jumpTo(0),
                child: const Icon(Icons.arrow_upward, size: 34, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

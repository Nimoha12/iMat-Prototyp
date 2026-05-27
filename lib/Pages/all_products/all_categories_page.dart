import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/product/product_filter_panel.dart';
import 'package:provider/provider.dart';

import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';

import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

import 'category_page.dart';
import 'recommended_products_page.dart';
import '../../Widgets/Category/category_quick_acess.dart';
import '../../Widgets/Category/categorized_product_sections.dart';
import '../../Widgets/Category/ui_categories.dart';
import '../../Widgets/Category/product_ui_category_extension.dart';
import '../../Widgets/Navigation/filter_button.dart';
import '../../Widgets/Navigation/breadcrumb_bar.dart'; // 

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";
  UiCategory? selectedCategory;

  bool filterOpen = false;

  final ScrollController _scrollController = ScrollController();
  bool showScrollButton = false;

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
    final List<Product> allProducts = iMat.selectProducts.cast<Product>();

    List<Product> applyFilters(List<Product> products) {
      List<Product> list = List<Product>.from(products);

      if (selectedCategory != null) {
        list = list.where((p) => p.uiCategory == selectedCategory).toList();
      }

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

    final filtered = applyFilters(allProducts);

    final Map<UiCategory, List<Product>> grouped = {};
    for (var cat in UiCategory.values) {
      grouped[cat] = filtered.where((p) => p.uiCategory == cat).toList();
    }

    final breadcrumbItems = [
      BreadcrumbItem(label: "Alla varor"),
    ];

    return IMatScaffold(
      breadcrumbContext: breadcrumbItems,
      body: Stack(
        children: [
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
                        BreadcrumbBar(items: breadcrumbItems),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 1396,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Alla varor", style: IMatText.h2),
                              FilterButton(
                                onPressed: () =>
                                    setState(() => filterOpen = true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        CategoryQuickAccessGrid(
                          onRecommendedTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RecommendedProductsPage(),
                              ),
                            );
                          },
                          onCategoryTap: (uiCat) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoryPage(uiCategory: uiCat),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                  ...CategorizedProductSections(
                    productsByCategory: grouped,
                    onCategoryHeaderTap: (uiCat) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryPage(uiCategory: uiCat),
                        ),
                      );
                    },
                  ).buildSlivers(),
                ],
              ),
            ),
          ),

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

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: filterOpen ? 0 : -350,
            top: 0,
            bottom: 0,
            child: ProductFilterPanel(
              maxPrice: maxPrice,
              onPriceChange: (v) => setState(() => maxPrice = v),
              ecoFilter: ecoFilter,
              onEcoChange: (v) => setState(() => ecoFilter = v),
              sortBy: sortBy,
              onSortChange: (v) => setState(() => sortBy = v),
              selectedCategory: selectedCategory,
              onCategoryChange: (v) => setState(() => selectedCategory = v),
              onClose: () => setState(() => filterOpen = false),
            ),
          ),

          if (showScrollButton)
            Positioned(
              right: 24,
              bottom: 24,
              child: FloatingActionButton(
                backgroundColor: IMatColors.green,
                onPressed: () => _scrollController.jumpTo(0),
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

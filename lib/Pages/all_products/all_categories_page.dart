import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/product_filter_panel.dart';
import 'package:provider/provider.dart';

import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';

import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

import 'category_page.dart';
import 'category_quick_acess.dart';
import 'categorized_product_sections.dart';
import 'ui_categories.dart';

import 'product_ui_category_extension.dart';

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

    return IMatScaffold(
      body: Stack(
        children: [
          // HUVUDINNEHÅLL
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SingleChildScrollView(
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
                            style: IMatText.bodyS.copyWith(
                              color: IMatColors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18),
                        Text(
                          "Alla varor",
                          style: IMatText.bodyS.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text("Alla varor", style: IMatText.h2),

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

                    CategoryQuickAccessGrid(
                      onCategoryTap: (uiCat) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryPage(uiCategory: uiCat),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    CategorizedProductSections(
                      productsByCategory: grouped,
                      onCategoryHeaderTap: (uiCat) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryPage(uiCategory: uiCat),
                          ),
                        );
                      },
                    ),
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
        ],
      ),
    );
  }
}

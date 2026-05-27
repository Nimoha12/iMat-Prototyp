import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/all_categories_page.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/Navigation/breadcrumb_bar.dart';
import 'package:imat_repo/Widgets/Navigation/filter_button.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/Widgets/product/product_filter_panel.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/AuthState.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/recommended_products.dart';
import 'package:provider/provider.dart';

class RecommendedProductsPage extends StatefulWidget {
  const RecommendedProductsPage({super.key});

  @override
  State<RecommendedProductsPage> createState() => _RecommendedProductsPageState();
}

class _RecommendedProductsPageState extends State<RecommendedProductsPage> {
  final ScrollController _scrollController = ScrollController();
  bool showScrollButton = false;

  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";
  bool filterOpen = false;

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

  List<Product> _applyFilters(List<Product> products) {
    var filtered = List<Product>.from(products);

    if (ecoFilter == EcoFilter.eco) {
      filtered = filtered.where((p) => p.isEcological).toList();
    } else if (ecoFilter == EcoFilter.inteEco) {
      filtered = filtered.where((p) => !p.isEcological).toList();
    }

    filtered = filtered.where((p) => p.price <= maxPrice).toList();

    if (sortBy == "priceAsc") {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == "priceDesc") {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final recommended = iMat.getRecommendedProducts(isLoggedIn: isLoggedIn);
    final filtered = _applyFilters(recommended);

    return IMatScaffold(
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
                            BreadcrumbItem(label: recommendedProductsTitle),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 1396,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                recommendedProductsTitle,
                                style: IMatText.h2,
                              ),
                              FilterButton(
                                onPressed: () =>
                                    setState(() => filterOpen = true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isLoggedIn
                              ? "Baserat på dina tidigare köp."
                              : "Populära varor att börja med.",
                          style: IMatText.bodyM.copyWith(
                            color: IMatColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  if (filtered.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "Inga produkter hittades",
                          style: IMatText.bodyL,
                        ),
                      ),
                    )
                  else
                    lazyProductGridSliver(filtered),
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
              selectedCategory: null,
              onCategoryChange: (_) {},
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

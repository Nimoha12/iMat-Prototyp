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
import '../../Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'category_page.dart';
import 'package:imat_repo/Widgets/product/filter_selection.dart';

class SubCategoryPage extends StatefulWidget {
  final String title;
  final List<ProductCategory> categories;
  final UiCategory parentCategory; // ny parameter för huvudkategori
  final bool showParentBreadcrumb;

  const SubCategoryPage({
    super.key,
    required this.title,
    required this.categories,
    required this.parentCategory, //  krävs nu vid anrop
    this.showParentBreadcrumb = true,
  });

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool showScrollButton = false;

  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";
  bool filterOpen = false;

  // används bara för att matcha ProductFilterPanel-signaturen,
  // men ingen kategori-filtering på denna sida
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

    // Filtrera produkter som tillhör denna underkategori
    var filtered = allProducts
        .where((p) => widget.categories.contains(p.category))
        .toList();

    // Ekologiskt-filter
    if (ecoFilter == EcoFilter.eco) {
      filtered = filtered.where((p) => p.isEcological).toList();
    } else if (ecoFilter == EcoFilter.inteEco) {
      filtered = filtered.where((p) => !p.isEcological).toList();
    }

    // Maxpris
    filtered = filtered.where((p) => p.price <= maxPrice).toList();

    // Sortering
    if (sortBy == "priceAsc") {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == "priceDesc") {
      filtered.sort((a, b) => b.price.compareTo(a.price));
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
      if (widget.showParentBreadcrumb)
        BreadcrumbItem(
          label: widget.parentCategory.label,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryPage(uiCategory: widget.parentCategory),
              ),
            );
          },
        ),
      BreadcrumbItem(label: widget.title),
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
                            BreadcrumbItem(
                              label: widget.parentCategory.label,
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryPage(
                                      uiCategory: widget.parentCategory,
                                    ),
                                  ),
                                );
                              },
                            ),
                            BreadcrumbItem(label: widget.title),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 1396,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.title, style: IMatText.h2),
                              FilterButton(
                                onPressed: () =>
                                    setState(() => filterOpen = true),
                              ),
                            ],
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

          // Filterpanel (utan kategoridel)
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
              selection: selection,
              onSelectionChanged: (s) => setState(() => selection = s),
              contextCategory: null,
              showCategoryFilter: false,
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

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
  // används bara för att matcha ProductFilterPanel-signaturen,
  // men ingen kategori-filtering på denna sida
  FilterSelection selection = const FilterSelection();

  void _openFilter(BuildContext context) {
    ProductFilterOverlay.show(
      context,
      maxPrice: maxPrice,
      ecoFilter: ecoFilter,
      sortBy: sortBy,
      selection: selection,
      showCategoryFilter: false,
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
            MaterialPageRoute(
              builder: (_) => const AllCategoriesPage(),
            ),
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
                builder: (_) => CategoryPage(
                  uiCategory: widget.parentCategory,
                ),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: BreadcrumbBar(items: breadcrumbItems),
                            ),
                            FilterButton(
                              onPressed: () => _openFilter(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(widget.title, style: IMatText.h2),
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

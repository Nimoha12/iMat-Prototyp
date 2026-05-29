import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/product/product_card.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Widgets/Navigation/filter_button.dart';
import '../../Widgets/Category/ui_categories.dart';
import '../../Widgets/product/product_filter_panel.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/Widgets/product/filter_selection.dart';

class AllProductsPage extends StatefulWidget {
  final UiCategory uiCategory;
  final String? subCategoryTitle;
  final List<ProductCategory>? subCategories;

  const AllProductsPage({
    super.key,
    required this.uiCategory,
    this.subCategoryTitle,
    this.subCategories,
  });

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";
  bool filterOpen = false;

  // Nytt: krävs av ProductFilterPanel
  FilterSelection selection = const FilterSelection();

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
    var products = iMat.selectProducts;

    // Vilka kategorier ska visas?
    final List<ProductCategory> cats =
        widget.subCategories ?? categoryMap[widget.uiCategory]!;

    // Filtrera på kategori
    products = products.where((p) => cats.contains(p.category)).toList();

    // Ekologiskt
    if (ecoFilter == EcoFilter.eco) {
      products = products.where((p) => p.isEcological).toList();
    } else if (ecoFilter == EcoFilter.inteEco) {
      products = products.where((p) => !p.isEcological).toList();
    }

    // Maxpris
    products = products.where((p) => p.price <= maxPrice).toList();

    // Sortering
    if (sortBy == "priceAsc") {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == "priceDesc") {
      products.sort((a, b) => b.price.compareTo(a.price));
    }

    final title = widget.subCategoryTitle ?? widget.uiCategory.label;

    return IMatScaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumbs
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Alla varor",
                              style: IMatText.bodyS.copyWith(
                                color: IMatColors.green,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            },
                            child: Text(
                              widget.uiCategory.label,
                              style: IMatText.bodyS.copyWith(
                                color: IMatColors.green,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          if (widget.subCategoryTitle != null) ...[
                            const Icon(Icons.chevron_right, size: 18),
                            Text(
                              widget.subCategoryTitle!,
                              style: IMatText.bodyS.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Titel + filterknapp
                      SizedBox(
                        width: 1396,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title, style: IMatText.h2),
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
                SliverGrid(
                  gridDelegate: productGridDelegate,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Align(
                      alignment: Alignment.topCenter,
                      child: ProductCard(product: products[index]),
                    ),
                    childCount: products.length,
                  ),
                ),
              ],
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

              // Nya obligatoriska parametrar
              selection: selection,
              onSelectionChanged: (s) => setState(() => selection = s),

              // Ingen kategori här
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

          // Scroll-to-top
          if (showScrollButton)
            Positioned(
              right: 24,
              bottom: 24,
              child: FloatingActionButton(
                backgroundColor: IMatColors.green,
                onPressed: () {
                  _scrollController.jumpTo(0);
                },
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

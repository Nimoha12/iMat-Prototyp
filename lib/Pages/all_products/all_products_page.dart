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
import '../../Widgets/product/product_filter_overlay.dart';
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
  // Nytt: krävs av ProductFilterPanel
  FilterSelection selection = const FilterSelection();

  final ScrollController _scrollController = ScrollController();
  bool showScrollButton = false;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
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
                    ),
                    FilterButton(
                      onPressed: () => _openFilter(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(title, style: IMatText.h2),

                const SizedBox(height: 24),

                // Produktgrid
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: products.length,
                    gridDelegate: productGridDelegate,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ProductCard(product: products[index]),
                      );
                    },
                  ),
                ),
              ],
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

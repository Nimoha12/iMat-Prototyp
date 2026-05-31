import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/product/product_card.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/imat_link_text.dart';
import 'package:imat_repo/Widgets/Navigation/filter_button.dart';
import '../../Widgets/Category/ui_categories.dart';
import '../../Widgets/product/product_filter_overlay.dart';
import '../../Widgets/product/product_filter_panel.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/Widgets/product/filter_selection.dart';

import 'package:imat_repo/Widgets/Navigation/scroll_to_top_button.dart';

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
  FilterSelection selection = const FilterSelection();

  final ScrollController _scrollController = ScrollController();

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    final List<ProductCategory> cats =
        widget.subCategories ?? categoryMap[widget.uiCategory]!;

    products = products.where((p) => cats.contains(p.category)).toList();

    if (ecoFilter == EcoFilter.eco) {
      products = products.where((p) => p.isEcological).toList();
    } else if (ecoFilter == EcoFilter.inteEco) {
      products = products.where((p) => !p.isEcological).toList();
    }

    products = products.where((p) => p.price <= maxPrice).toList();

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
                          IMatLinkText(
                            text: 'Hem',
                            style: IMatText.bodyS,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            },
                          ),
                          const Icon(Icons.chevron_right, size: 18),
                          IMatLinkText(
                            text: 'Alla varor',
                            style: IMatText.bodyS,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            },
                          ),
                          const Icon(Icons.chevron_right, size: 18),
                          IMatLinkText(
                            text: widget.uiCategory.label,
                            style: IMatText.bodyS,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            },
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
                            FilterButton(onPressed: () => _openFilter(context)),
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

          // GLOBAL scroll-to-top button
          ScrollToTopButton(controller: _scrollController),
        ],
      ),
    );
  }
}

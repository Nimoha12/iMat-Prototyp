import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

import 'ui_categories.dart';
import 'product_card.dart';
import 'product_filter_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    // Vilka kategorier ska visas?
    final List<ProductCategory> cats =
        widget.subCategories ?? categoryMap[widget.uiCategory]!;

    products = products.where((p) => cats.contains(p.category)).toList();

    // Ekologiskt-filter
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb: Hem > Alla varor > Kategori > (ev. underkategori)
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
                    style: IMatText.bodyS.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            Text(title, style: IMatText.h2),
            const SizedBox(height: 24),

            // Filterrad
            ProductFilterBar(
              maxPrice: maxPrice,
              onPriceChange: (v) => setState(() => maxPrice = v),
              ecoFilter: ecoFilter,
              onEcoChange: (v) => setState(() => ecoFilter = v),
              sortBy: sortBy,
              onSortChange: (v) => setState(() => sortBy = v),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/category_quick_acess.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

import 'category_page.dart';

// nya imports
import 'product_filter_bar.dart';
import 'product_grid.dart';
import 'package:imat_repo/model/imat/product.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    final List<Product> allProducts = iMat.selectProducts.cast<Product>();

    List<Product> applyFilters(List<Product> products) {
      List<Product> list = List<Product>.from(products);

      if (ecoFilter == EcoFilter.eco) {
        list = list.where((p) => p.isEcological).toList();
      } else if (ecoFilter == EcoFilter.inteEco) {
        list = list.where((p) => !p.isEcological).toList();
      }

      list = list.where((p) => p.price <= maxPrice).toList();

      if (sortBy == "priceAsc") {
        list.sort((Product a, Product b) => a.price.compareTo(b.price));
      } else if (sortBy == "priceDesc") {
        list.sort((Product a, Product b) => b.price.compareTo(a.price));
      }

      return list;
    }

    final filtered = applyFilters(allProducts);

    return IMatScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb: Hem > Alla varor
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
                    style: IMatText.bodyS.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text("Alla varor", style: IMatText.h2),

              const SizedBox(height: 24),

              ProductFilterBar(
                maxPrice: maxPrice,
                onPriceChange: (v) => setState(() => maxPrice = v),
                ecoFilter: ecoFilter,
                onEcoChange: (v) => setState(() => ecoFilter = v),
                sortBy: sortBy,
                onSortChange: (v) => setState(() => sortBy = v),
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

              ProductGrid(products: filtered),
            ],
          ),
        ),
      ),
    );
  }
}

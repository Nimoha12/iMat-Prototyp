import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/product_card.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

class SubCategoryPage extends StatelessWidget {
  final String title;
  final List<ProductCategory> categories;

  const SubCategoryPage({
    super.key,
    required this.title,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final allProducts = iMat.selectProducts;

    final filtered = allProducts
        .where((p) => categories.contains(p.category))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: IMatColors.green,
        foregroundColor: IMatColors.onGreen,
        title: Text(
          title,
          style: IMatText.h3.copyWith(color: IMatColors.onGreen),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: filtered.isEmpty
            ? Center(
                child: Text("Inga produkter hittades", style: IMatText.bodyL),
              )
            : Wrap(
                spacing: 24,
                runSpacing: 24,
                children: filtered.map((product) {
                  return SizedBox(
                    width: 260,
                    child: ProductCard(product: product),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

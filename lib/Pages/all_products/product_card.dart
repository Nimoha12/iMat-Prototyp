import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat/shopping_item.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final iMat = Provider.of<ImatDataHandler>(
      context,
      listen: false,
    );

    final unit = product.unit.replaceAll("kr/", "");

    return Container(
      decoration: BoxDecoration(
        color: IMatColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: IMatColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 140,
            child: iMat.getImage(product),
          ),

          const SizedBox(height: 16),

          Text(
            product.name,
            style: IMatText.bodyL.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          Text(
            "${product.price.toStringAsFixed(2)} kr/$unit",
            style: IMatText.bodyM.copyWith(
              color: IMatColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: IMatColors.green,
                foregroundColor: IMatColors.white,
                elevation: 0,
                textStyle: IMatText.bodyM.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                iMat.shoppingCartAdd(
                  ShoppingItem(product, amount: 1),
                );
              },
              child: const Text("Lägg till"),
            ),
          ),
        ],
      ),
    );
  }
}
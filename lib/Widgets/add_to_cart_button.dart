import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat/shopping_item.dart';
import 'package:imat_repo/model/imat/shopping_cart.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;

  const AddToCartButton({super.key, required this.product});

  int getAmount(ShoppingCart cart, Product product) {
    for (final item in cart.items) {
      if (item.product.productId == product.productId) {
        return item.amount.toInt();
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart();

    final int quantity = getAmount(cart, product);

    // --- 1. INTE I KUNDVAGNEN ---
    if (quantity == 0) {
      return GestureDetector(
        onTap: () {
          iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: IMatColors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 26),
              const SizedBox(width: 8),
              Text(
                "Lägg till",
                style: IMatText.bodyL.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- 2. I KUNDVAGNEN → MÄNGDKONTROLL ---
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: IMatColors.greenLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IMatColors.green, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // MINUS
          GestureDetector(
            onTap: () {
              if (quantity > 1) {
                iMat.shoppingCartUpdate(
                  ShoppingItem(product),
                  delta: -1,
                );
              } else {
                iMat.shoppingCartRemove(
                  ShoppingItem(product),
                );
              }
            },
            child: Container(
              width: 52,
              height: double.infinity,
              decoration: BoxDecoration(
                color:IMatColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.remove, size: 28, color: IMatColors.white),
            ),
          ),

          // ANTAL
          Text(
            quantity.toString(),
            style: IMatText.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: IMatColors.black,
            ),
          ),

          // PLUS
          GestureDetector(
            onTap: () {
              iMat.shoppingCartUpdate(
                ShoppingItem(product),
                delta: 1,
              );
            },
            child: Container(
              width: 52,
              height: double.infinity,
              decoration: BoxDecoration(
                color: IMatColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, size: 28, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

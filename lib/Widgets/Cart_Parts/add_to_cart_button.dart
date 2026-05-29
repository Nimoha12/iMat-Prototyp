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
  final double? width;

  const AddToCartButton({super.key, required this.product, this.width});

  int getAmount(ShoppingCart cart, Product product) {
    for (final item in cart.items) {
      if (item.product.productId == product.productId) {
        return item.amount.toInt();
      }
    }
    return 0;
  }

  Future<void> _showEditAmountDialog(
    BuildContext context,
    int currentAmount,
    ImatDataHandler iMat,
  ) async {
    final controller = TextEditingController(text: currentAmount.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: IMatColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 24,
          ), // större dialog
          titlePadding: const EdgeInsets.fromLTRB(32, 32, 32, 12),
          contentPadding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 14),

          title: Text(
            "Ange antal",
            style: IMatText.headingL.copyWith(
              color: IMatColors.green,
            )
              // större text
          ),

          content: SizedBox(
            width: 360, // gör dialogen bredare
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: IMatText.bodyL, // större text
              decoration: InputDecoration(
                hintText: "Skriv antal...",
                hintStyle: IMatText.bodyM.copyWith(
                  color: IMatColors.textSecondary,
                ),
                filled: true,
                fillColor: IMatColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 22, // större klickyta
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: IMatColors.border,
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ),

          actions: [
            SizedBox(
              height: 58, // större knappar
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Avbryt", style: IMatText.bodyL.copyWith(
                  fontWeight: FontWeight.w600
                ),),
              ),
            ),
            SizedBox(
              height: 58,
              child: TextButton(
                onPressed: () {
                  final value = int.tryParse(controller.text);

                  if (value == null || value < 0) {
                    Navigator.pop(context);
                    return;
                  }

                  if (value == 0) {
                    iMat.shoppingCartRemove(ShoppingItem(product));
                  } else {
                    iMat.shoppingCartSet(
                      ShoppingItem(product, amount: value.toDouble()),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text("OK", style: IMatText.bodyL.copyWith(
                   fontWeight: FontWeight.w600

                )),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart();
    final int quantity = getAmount(cart, product);

    // INTE I KUNDVAGNEN
    if (quantity == 0) {
      return GestureDetector(
        onTap: () {
          iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
        },
        child: Container(
          width: width,
          height: 52,
          decoration: BoxDecoration(
            color: IMatColors.green,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: IMatColors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                "Lägg till",
                style: IMatText.bodyM.copyWith(
                  color: IMatColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    //  KUNDVAGNEN
    return Container(
      width: width,
      height: 52,
      decoration: BoxDecoration(
        color: IMatColors.greenLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: IMatColors.green, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // MINUS
          GestureDetector(
            onTap: () {
              if (quantity > 1) {
                iMat.shoppingCartUpdate(ShoppingItem(product), delta: -1);
              } else {
                iMat.shoppingCartRemove(ShoppingItem(product));
              }
            },
            child: Container(
              width: 56,
              height: double.infinity,
              decoration: BoxDecoration(
                color: IMatColors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.remove,
                size: 24,
                color: IMatColors.white,
              ),
            ),
          ),

          // ANTAL
          GestureDetector(
            behavior:
                HitTestBehavior.translucent, // fångar ALLA klick i området
            onTap: () => _showEditAmountDialog(context, quantity, iMat),
            child: Container(
              width: 92,
              height: double.infinity,
              alignment: Alignment.center,
              child: Text(
                quantity.toString(),
                style: IMatText.bodyL.copyWith(
                  fontWeight: FontWeight.w800,
                  color: IMatColors.black,
                ),
              ),
            ),
          ),

          // PLUS
          GestureDetector(
            onTap: () {
              iMat.shoppingCartUpdate(ShoppingItem(product), delta: 1);
            },
            child: Container(
              width: 56,
              height: double.infinity,
              decoration: BoxDecoration(
                color: IMatColors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, size: 24, color: IMatColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

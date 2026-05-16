import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';

class CartButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CartButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          color: IMatColors.green,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: IMatColors.white.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                color: IMatColors.white,
                size: 24,
              ),

              const SizedBox(width: 10),

              Text(
                "Varukorg",
                style: IMatText.bodyM.copyWith(
                  color: IMatColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
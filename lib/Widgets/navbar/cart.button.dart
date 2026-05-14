import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';

class CartButton extends StatelessWidget {
  final VoidCallback? onTap; // 

  const CartButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 🔹 Gör hela knappen klickbar
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: IMatColors.softGreen,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: IMatColors.accent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              "Varukorg",
              style: IMatText.bodyM.copyWith(
                color: IMatColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

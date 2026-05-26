import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class CartButton extends StatefulWidget {
  final VoidCallback? onTap;

  const CartButton({super.key, this.onTap});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _popController;

  @override
  void initState() {
    super.initState();

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 0.20, // lite större pop nu när ikonen är större
    );
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  void triggerPop() {
    _popController.forward().then((_) {
      _popController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart();
    final totalItems = cart.totalItems;

    // Trigger animation when cart changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_popController.isDismissed && totalItems > 0) {
        triggerPop();
      }
    });

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          color: IMatColors.greenHover,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: IMatColors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 1.20).animate(
                      CurvedAnimation(
                        parent: _popController,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: IMatColors.white,
                      size: 30, // större ikon
                    ),
                  ),

                  if (totalItems > 0)
                    Positioned(
                      right: -12, // flytta ut lite mer
                      top: -12,
                      child: Container(
                        padding: const EdgeInsets.all(8), // större badge
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15, // större text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

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

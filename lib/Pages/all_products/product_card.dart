import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/add_to_cart_button.dart';
import 'package:imat_repo/Widgets/home/login_overlay_scope.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _popController;

  @override
  void initState() {
    super.initState();

    // Pop animation controller for the favorite button
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.15,
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
    final isFavorite = iMat.isFavorite(widget.product);

    final loginScope = LoginOverlayScope.maybeOf(context);

    final unit = widget.product.unit.replaceAll("kr/", "");

    return Container(
      decoration: BoxDecoration(
        color: IMatColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IMatColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
            child: Stack(
              children: [
                Positioned.fill(child: iMat.getImage(widget.product)),

                // Improved favorite button with pop animation and login check
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // If not logged in, show login popup instead of toggling favorite
                      if (loginScope != null && !loginScope.isLoggedIn) {
                        loginScope.showLoginOverlay();
                        return;
                      }

                      // Logged in: animate and toggle favorite
                      triggerPop();
                      iMat.toggleFavorite(widget.product);
                    },
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 1.15)
                          .animate(CurvedAnimation(
                        parent: _popController,
                        curve: Curves.easeOut,
                      )),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFavorite ? Colors.red : IMatColors.green,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 30,
                          color: isFavorite ? Colors.red : IMatColors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            widget.product.name,
            style: IMatText.bodyL.copyWith(fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          Text(
            "${widget.product.price.toStringAsFixed(2)} kr/$unit",
            style: IMatText.bodyM.copyWith(
              color: IMatColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          AddToCartButton(product: widget.product),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/model/imat/product.dart';

import 'product_detail_widget.dart';

class ProductDetailOverlay extends StatelessWidget {
  final Product product;

  const ProductDetailOverlay({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.48),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelWidth = math.min(constraints.maxWidth - 32, 980.0);
            final panelHeight = math.min(constraints.maxHeight - 32, 760.0);

            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: panelWidth,
                    height: panelHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Material(
                            color: IMatColors.white,
                            elevation: 18,
                            shadowColor: Colors.black.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: ProductDetailWidget(product: product),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Semantics(
                            button: true,
                            label: 'Stäng produktinformation',
                            child: IconButton.filled(
                              onPressed: () => Navigator.of(context).pop(),
                              style: IconButton.styleFrom(
                                backgroundColor: IMatColors.white,
                                foregroundColor: IMatColors.black,
                                fixedSize: const Size(56, 56),
                                side: const BorderSide(
                                  color: IMatColors.border,
                                ),
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(Icons.close, size: 32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'product_detail_widget.dart';

class ProductDetailOverlay extends StatelessWidget {
  final Product product;

  const ProductDetailOverlay({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Klick utanför stänger overlay
      onTap: () => Navigator.pop(context),

      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.45),

        body: Center(
          child: GestureDetector(
            // Hindrar klick inne i kortet från att bubbla ut
            onTap: () {},

            child: AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,

              child: Stack(
                children: [
                  // Själva produktdetaljen
                  Container(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ProductDetailWidget(product: product),
                  ),

                  // Stäng-knapp nära kortet (inte i hörnet)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.close, size: 30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

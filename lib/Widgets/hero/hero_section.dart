import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/recommended_products_page.dart';
import 'package:imat_repo/Theme/imat_theme.dart';
import 'package:imat_repo/model/recommended_products.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _hovered = false; // hover state

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RecommendedProductsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),

      child: GestureDetector(
        onTap: () => _onTap(context),

        // Lösning A: padding runt hela hover-kortet
        child: Padding(
          padding: const EdgeInsets.all(4), // ger utrymme för scale-animation

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()..scale(_hovered ? 1.04 : 1.0),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _hovered ? 0.14 : 0.08),
                  blurRadius: _hovered ? 10 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: SizedBox(
              height: 260,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/hero_bg.jpg',
                      fit: BoxFit.cover,
                    ),

                    Container(
                      color: IMatColors.green.withValues(alpha: 0.45),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Välkommen till iMat",
                            style: IMatText.headingXL.copyWith(
                              fontSize: 34,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "Din matbutik på nätet",
                            style: IMatText.bodyL.copyWith(
                              color: IMatColors.white,
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton(
                            style: IMatButton.primary.copyWith(
                              backgroundColor:
                                  const WidgetStatePropertyAll(IMatColors.white),
                            ),
                            onPressed: () => _onTap(context),
                            child: Text(recommendedProductsTitle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

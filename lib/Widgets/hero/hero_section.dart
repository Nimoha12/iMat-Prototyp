import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';

// Visar den stora hero-bilden högst upp på startsidan.
// Matchar layout och höjd med Alla varor-kortet.

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/hero_bg.jpg',
            fit: BoxFit.cover,
          ),

          Container(
            color: IMatColors.green.withValues(alpha: 0.40),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 28,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Välkommen till iMat",
                  style: IMatText.headingXL,
                ),

                const SizedBox(height: 10),

                Text(
                  "Din matbutik på nätet",
                  style: IMatText.bodyL.copyWith(
                    color: IMatColors.white,
                  ),
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  style: IMatButton.primary,
                  onPressed: () {},
                  child: const Text(
                    "Handla populära varor",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
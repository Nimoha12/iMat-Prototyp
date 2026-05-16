import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                          WidgetStatePropertyAll(IMatColors.white),
                    ),
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
      ),
    );
  }
}
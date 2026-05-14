import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'resources-api_test-v3/__MACOSX/resources-api_test-v3/assets/images/hero_bg.jpg',
            fit: BoxFit.cover,
          ),

          Container(
            color: IMatColors.green.withValues(alpha: 0.40),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Välkommen till iMat", style: IMatText.headingXL),
                const SizedBox(height: 10),
                Text("Din matbutik på nätet",
                    style: IMatText.bodyL.copyWith(color: IMatColors.white)),
                const SizedBox(height: 26),

                ElevatedButton(
                  style: IMatButton.primary,
                  onPressed: () {},
                  child: const Text("Handla populära varor"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

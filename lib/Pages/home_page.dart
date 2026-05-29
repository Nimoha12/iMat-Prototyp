import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';
import 'package:imat_repo/Widgets/home/all_items_card.dart';
import 'package:imat_repo/Widgets/hero/hero_section.dart';
import 'package:imat_repo/Widgets/home/category_grid/category_grid_home.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IMatNavbar(),
      body: ListView(
        children: [
          // Hero + Alla varor
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 22,
              bottom: 8,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 16.0;

                // Säker beräkning av kortbredd
                final availableWidth = math.max(
                  constraints.maxWidth - (spacing * 2),
                  0,
                );
                final cardWidth = availableWidth / 3;

                return SizedBox(
                  height: 260,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Vänster: HeroSection (2 kolumner)
                      SizedBox(
                        width: (cardWidth * 2) + spacing,
                        child: const HeroSection(),
                      ),

                      const SizedBox(width: spacing),

                      // Höger: Alla varor
                      SizedBox(width: cardWidth, child: const AllItemsCard()),
                    ],
                  ),
                );
              },
            ),
          ),

          // Rubrik: Populära kategorier
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("Populära kategorier", style: IMatText.headingL),
          ),

          const SizedBox(height: 10),

          // Grid med kategorier
          const CategoryGridHome(),
        ],
      ),
    );
  }
}

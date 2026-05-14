import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';
import 'package:imat_repo/Widgets/home/all_items_card.dart';
import 'package:imat_repo/Widgets/hero/hero_section.dart';
import 'package:imat_repo/Widgets/home/category_grid/category_grid_home.dart';
import 'package:imat_repo/Widgets/navbar/navbar.dart';

// Bygger hela startsidan för iMat.
// Hero och Alla varor har nu exakt samma alignment som kategorigriden.

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IMatNavbar(),
      body: ListView(
        children: [
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

                // Samma matematik som 3-kolumns grid
                final cardWidth =
                    (constraints.maxWidth - (spacing * 2)) / 3;

                return SizedBox(
                  height: 260,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (cardWidth * 2) + spacing,
                        child: const HeroSection(),
                      ),

                      const SizedBox(width: spacing),

                      SizedBox(
                        width: cardWidth,
                        child: const AllItemsCard(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Populära kategorier",
              style: IMatText.headingL,
            ),
          ),

          const SizedBox(height: 10),

          const CategoryGridHome(),
        ],
      ),
    );
  }
}
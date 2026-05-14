import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';
import 'package:imat_repo/Widgets/hero/hero_section.dart';
import 'package:imat_repo/Widgets/home/all_items_card.dart';
import 'package:imat_repo/Widgets/home/category_grid/category_grid_home.dart';
import 'package:imat_repo/Widgets/navbar/navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IMatNavbar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: 350,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Expanded(flex: 2, child: HeroSection()),
                  SizedBox(width: 24),
                  Expanded(flex: 1, child: AllItemsCard()),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("Populära kategorier", style: IMatText.headingL),
          ),

          const SizedBox(height: 16),
          const CategoryGridHome(),
        ],
      ),
    );
  }
}

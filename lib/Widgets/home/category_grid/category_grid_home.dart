import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Widgets/home/category_grid/category.dart';

//Visar 6 utvalda kategorier på startsdian 
//Det är inte alla kategorier, bara de vanliga

class CategoryGridHome extends StatelessWidget {
  const CategoryGridHome({super.key});

  final List<Category> homeCategories = const [
    Category(category: ProductCategory.DAIRIES, label: "Mejeri & Ägg", icon: Icons.egg),
    Category(category: ProductCategory.VEGETABLE_FRUIT, label: "Frukt & Grönt", icon: Icons.eco),
    Category(category: ProductCategory.MEAT, label: "Kött", icon: Icons.set_meal),
    Category(category: ProductCategory.BREAD, label: "Bröd", icon: Icons.bakery_dining),
    Category(category: ProductCategory.COLD_DRINKS, label: "Drycker", icon: Icons.local_drink),
    Category(category: ProductCategory.PASTA, label: "Torrvaror", icon: Icons.rice_bowl),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double maxGridWidth = screenWidth > 1200 ? 900.0 : screenWidth - 48.0;


    return Center(
      child: SizedBox(
        width: maxGridWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 per rad = 6 totalt i två rader
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1, // 👈
            ),
            itemBuilder: (context, index) {
              final category = homeCategories[index];
              return _CategoryCard(category: category);
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 32, color: IMatColors.black),
            const SizedBox(height: 8),
            Text(
              category.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

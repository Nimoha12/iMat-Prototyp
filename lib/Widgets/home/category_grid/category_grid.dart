import 'package:flutter/material.dart';
import 'category.dart';

//Den här filen visar alla produktkategoruer i ett rutnät (grid)
//Varje kategori har ett namn och en ikon 
//När man klickar på en kategori kan man gå till den sidan
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  final List<Category> categories = const [
    Category(category: ProductCategory.MELONS, label: "Meloner", icon: Icons.local_florist),
    Category(category: ProductCategory.FLOUR_SUGAR_SALT, label: "Mjöl, Socker & Salt", icon: Icons.cookie),
    Category(category: ProductCategory.MEAT, label: "Kött", icon: Icons.set_meal),
    Category(category: ProductCategory.DAIRIES, label: "Mejeri & Ägg", icon: Icons.egg),
    Category(category: ProductCategory.VEGETABLE_FRUIT, label: "Frukt & Grönt", icon: Icons.eco),
    Category(category: ProductCategory.CABBAGE, label: "Kål", icon: Icons.grass),
    Category(category: ProductCategory.NUTS_AND_SEEDS, label: "Nötter & Frön", icon: Icons.nature),
    Category(category: ProductCategory.PASTA, label: "Pasta", icon: Icons.rice_bowl),
    Category(category: ProductCategory.POTATO_RICE, label: "Potatis & Ris", icon: Icons.set_meal_outlined),
    Category(category: ProductCategory.ROOT_VEGETABLE, label: "Rotfrukter", icon: Icons.eco_outlined),
    Category(category: ProductCategory.FRUIT, label: "Frukt", icon: Icons.apple),
    Category(category: ProductCategory.SWEET, label: "Sötsaker", icon: Icons.cake),
    Category(category: ProductCategory.HERB, label: "Örter", icon: Icons.local_florist),
    Category(category: ProductCategory.POD, label: "Baljväxter", icon: Icons.spa),
    Category(category: ProductCategory.BREAD, label: "Bröd", icon: Icons.bakery_dining),
    Category(category: ProductCategory.BERRY, label: "Bär", icon: Icons.grain),
    Category(category: ProductCategory.CITRUS_FRUIT, label: "Citrusfrukter", icon: Icons.sunny),
    Category(category: ProductCategory.HOT_DRINKS, label: "Varma drycker", icon: Icons.local_cafe),
    Category(category: ProductCategory.COLD_DRINKS, label: "Kalla drycker", icon: Icons.local_drink),
    Category(category: ProductCategory.EXOTIC_FRUIT, label: "Exotisk frukt", icon: Icons.travel_explore),
    Category(category: ProductCategory.FISH, label: "Fisk", icon: Icons.set_meal),

  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(category: category);
        },
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
      onTap: () {
        // TODO: Navigera till kategori-sida baserat på category.category
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Icon(category.icon, size: 40, color: Colors.black87),
            const SizedBox(height: 12),
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

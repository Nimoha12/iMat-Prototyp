import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Widgets/home/category_grid/category.dart';

class CategoryGridHome extends StatelessWidget {
  const CategoryGridHome({super.key});

  final List<Category> homeCategories = const [
    Category(
      category: ProductCategory.DAIRIES,
      label: "Mejeri & Ägg",
      icon: Icons.egg,
      bgImagePath: "assets/category_bg/dairy.jpg",
    ),
    Category(
      category: ProductCategory.VEGETABLE_FRUIT,
      label: "Frukt & Grönt",
      icon: Icons.eco,
      bgImagePath: "assets/category_bg/fruitveg.jpg",
    ),
    Category(
      category: ProductCategory.MEAT,
      label: "Kött & fisk",
      iconPath: "assets/icons/meat.png",
      bgImagePath: "assets/category_bg/meatfish.jpg",
    ),
    Category(
      category: ProductCategory.BREAD,
      label: "Bröd",
      iconPath: "assets/icons/bread.png",
      bgImagePath: "assets/category_bg/bread.jpg",
    ),
    Category(
      category: ProductCategory.COLD_DRINKS,
      label: "Drycker",
      icon: Icons.local_drink,
      bgImagePath: "assets/category_bg/drinks.jpg",
    ),
    Category(
      category: ProductCategory.PASTA,
      label: "Torrvaror",
      iconPath: "assets/icons/grains.png",
      bgImagePath: "assets/category_bg/pantry.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double maxGridWidth = screenWidth > 1400 ? 1200.0 : screenWidth - 48.0;

    return Center(
      child: SizedBox(
        width: maxGridWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.0,
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
    final hasImage = category.bgImagePath != null;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  category.bgImagePath!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            if (hasImage)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withValues(alpha: 0.25),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (category.iconPath != null)
                    Image.asset(
                      category.iconPath!,
                      width: 40,
                      height: 40,
                      color: hasImage ? Colors.white : IMatColors.black,
                    )
                  else if (category.icon != null)
                    Icon(
                      category.icon!,
                      size: 40,
                      color: hasImage ? Colors.white : IMatColors.black,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    category.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: hasImage ? Colors.white : IMatColors.black,
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

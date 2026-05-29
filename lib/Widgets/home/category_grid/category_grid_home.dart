import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Widgets/home/category_grid/category.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Pages/all_products/category_page.dart';

extension CategoryToUi on Category {
  UiCategory get uiCategory {
    for (final entry in categoryMap.entries) {
      if (entry.value.contains(category)) {
        return entry.key;
      }
    }
    return UiCategory.fruktOchGront;
  }
}

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
              return _HoverCategoryCard(category: category);
            },
          ),
        ),
      ),
    );
  }
}

class _HoverCategoryCard extends StatefulWidget {
  final Category category;

  const _HoverCategoryCard({required this.category});

  @override
  State<_HoverCategoryCard> createState() => _HoverCategoryCardState();
}

class _HoverCategoryCardState extends State<_HoverCategoryCard> {
  bool _hovered = false;

  void _onTap(BuildContext context) {
    final uiCat = widget.category.uiCategory;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryPage(uiCategory: uiCat),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final hasImage = category.bgImagePath != null;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _onTap(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.04 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.14 : 0.08),
                blurRadius: _hovered ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                if (hasImage)
                  Positioned.fill(
                    child: Image.asset(
                      category.bgImagePath!,
                      fit: BoxFit.cover,
                    ),
                  ),

                if (hasImage)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(
                        alpha: _hovered ? 0.25 : 0.35,
                      ),
                    ),
                  ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (category.iconPath != null)
                        Image.asset(
                          category.iconPath!,
                          width: 60,
                          height: 60,
                          color: Colors.white,
                        )
                      else if (category.icon != null)
                        Icon(
                          category.icon!,
                          size: 60,
                          color: Colors.white,
                        ),

                      const SizedBox(height: 14),

                      Text(
                        category.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
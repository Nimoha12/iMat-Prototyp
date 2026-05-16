import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

import 'ui_categories.dart';
import 'product_card.dart';
import 'product_filter_bar.dart'; // filter import
import 'all_categories_page.dart';

// Visar en kategori-sida (t.ex. Frukt & Grönt) med alla underkategorier

class _SubCategoryGroup {
  final String title;
  final List<ProductCategory> categories;

  const _SubCategoryGroup(this.title, this.categories);
}

// Definiera underkategorier per huvudkategori
final Map<UiCategory, List<_SubCategoryGroup>> subCategoryGroups = {
  UiCategory.fruktOchGront: [
    _SubCategoryGroup("Rotfrukter", [ProductCategory.ROOT_VEGETABLE]),
    _SubCategoryGroup("Bär", [ProductCategory.BERRY]),
    _SubCategoryGroup("Meloner", [ProductCategory.MELONS]),
    _SubCategoryGroup("Kål", [ProductCategory.CABBAGE]),
    _SubCategoryGroup("Örter", [ProductCategory.HERB]),
    _SubCategoryGroup("Grönsaker", [ProductCategory.VEGETABLE_FRUIT]),
    _SubCategoryGroup("Frukt", [
      ProductCategory.FRUIT,
      ProductCategory.EXOTIC_FRUIT,
      ProductCategory.CITRUS_FRUIT,
    ]),
  ],

  UiCategory.kottOchFisk: [
    _SubCategoryGroup("Kött", [ProductCategory.MEAT]),
    _SubCategoryGroup("Fisk", [ProductCategory.FISH]),
  ],

  UiCategory.mejeriAgg: [
    _SubCategoryGroup("Mejeri & Ägg", [ProductCategory.DAIRIES]),
  ],

  UiCategory.torrvaror: [
    _SubCategoryGroup("Pasta & Ris", [
      ProductCategory.PASTA,
      ProductCategory.POTATO_RICE,
    ]),
    _SubCategoryGroup("Mjöl, socker & salt", [
      ProductCategory.FLOUR_SUGAR_SALT,
    ]),
    _SubCategoryGroup("Baljväxter & Nötter", [
      ProductCategory.POD,
      ProductCategory.NUTS_AND_SEEDS,
    ]),
  ],

  UiCategory.brod: [
    _SubCategoryGroup("Bröd", [ProductCategory.BREAD]),
  ],

  UiCategory.snacks: [
    _SubCategoryGroup("Snacks & Sötsaker", [ProductCategory.SWEET]),
  ],

  UiCategory.dryck: [
    _SubCategoryGroup("Kalla drycker", [ProductCategory.COLD_DRINKS]),
    _SubCategoryGroup("Varma drycker", [ProductCategory.HOT_DRINKS]),
  ],
};

class CategoryPage extends StatefulWidget {
  final UiCategory uiCategory;

  const CategoryPage({super.key, required this.uiCategory});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Filter-state (flyttat hit så CategoryPage alltid har filter)
  double maxPrice = 200;
  EcoFilter ecoFilter = EcoFilter.alla;
  String sortBy = "none";

  // ScrollController för snabbnavigering
  final ScrollController scrollController = ScrollController();
  final Map<String, GlobalKey> sectionKeys = {};

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final allProducts = iMat.selectProducts;
    final groups = subCategoryGroups[widget.uiCategory] ?? [];

    // Förbered keys för varje sektion
    for (var g in groups) {
      sectionKeys[g.title] = GlobalKey();
    }

    // Filtrering appliceras här
    List<Product> applyFilters(List<Product> products) {
      var list = products;

      if (ecoFilter == EcoFilter.eco) {
        list = list.where((p) => p.isEcological).toList();
      } else if (ecoFilter == EcoFilter.inteEco) {
        list = list.where((p) => !p.isEcological).toList();
      }

      list = list.where((p) => p.price <= maxPrice).toList();

      if (sortBy == "priceAsc") {
        list.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortBy == "priceDesc") {
        list.sort((a, b) => b.price.compareTo(a.price));
      }

      return list;
    }

    return IMatScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb: Hem > Alla varor > Kategori
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Hem",
                      style: IMatText.bodyL.copyWith(
                        color: IMatColors.green,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.chevron_right,
                      size: 24,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AllCategoriesPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Alla varor",
                      style: IMatText.bodyL.copyWith(
                        color: IMatColors.green,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.chevron_right,
                      size: 24,
                    ),
                  ),

                  Text(
                    widget.uiCategory.label,
                    style: IMatText.bodyL.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                widget.uiCategory.label,
                style: IMatText.h2,
              ),

              const SizedBox(height: 24),

              // Filter ALLTID synligt
              ProductFilterBar(
                maxPrice: maxPrice,
                onPriceChange: (v) => setState(() => maxPrice = v),
                ecoFilter: ecoFilter,
                onEcoChange: (v) => setState(() => ecoFilter = v),
                sortBy: sortBy,
                onSortChange: (v) => setState(() => sortBy = v),
              ),

              const SizedBox(height: 24),

              // Snabbnavigering
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: groups.map((g) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      final key = sectionKeys[g.title]!;

                      Scrollable.ensureVisible(
                        key.currentContext!,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: IMatColors.greenLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: IMatColors.border,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 16,
                        ),
                        child: Text(
                          g.title,
                          style: IMatText.bodyM.copyWith(
                            fontWeight: FontWeight.w700,
                            color: IMatColors.green,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Alla sektioner med ALLA produkter
              ...groups.map((group) {
                final subProducts = allProducts
                    .where((p) => group.categories.contains(p.category))
                    .toList();

                final filtered = applyFilters(subProducts);

                if (filtered.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  key: sectionKeys[group.title],
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.title,
                        style: IMatText.h3,
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: filtered.map((product) {
                          return SizedBox(
                            width: 260,
                            child: ProductCard(product: product),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/category_page.dart';
import 'package:provider/provider.dart';
import 'package:imat_repo/Pages/all_products/categorized_product_sections.dart';
import 'package:imat_repo/Pages/all_products/ui_categories.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat_data_handler.dart';

class SearchPage extends StatefulWidget {
  final String query;

  const SearchPage({super.key, required this.query});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController scrollController = ScrollController();
  final Map<UiCategory, GlobalKey> sectionKeys = {};

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ImatDataHandler>().products;
    final query = widget.query.trim();
    final searchResult = _rankSearchResults(products, query);

    for (final uiCategory in searchResult.productsByCategory.keys) {
      sectionKeys.putIfAbsent(uiCategory, GlobalKey.new);
    }

    return IMatScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    child: Icon(Icons.chevron_right, size: 24),
                  ),
                  Text(
                    "Sök",
                    style: IMatText.bodyL.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Sökresultat för "$query"', style: IMatText.h2),
              const SizedBox(height: 24),
              if (products.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (query.isEmpty)
                Text(
                  "Skriv något i sökrutan för att hitta varor.",
                  style: IMatText.bodyM.copyWith(
                    color: IMatColors.textSecondary,
                  ),
                )
              else if (searchResult.productsByCategory.isEmpty)
                Text(
                  "Inga produkter matchar sökningen.",
                  style: IMatText.bodyM.copyWith(
                    color: IMatColors.textSecondary,
                  ),
                )
              else
                CategorizedProductSections(
                  productsByCategory: searchResult.productsByCategory,
                  onCategoryHeaderTap: (uiCat){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryPage(uiCategory: uiCat)));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResult {
  final Map<UiCategory, List<Product>> productsByCategory;

  const _SearchResult(this.productsByCategory);
}

class _ScoredCategory {
  final UiCategory category;
  final List<_ScoredProduct> products;
  final double score;

  const _ScoredCategory(this.category, this.products, this.score);
}

class _ScoredProduct {
  final Product product;
  final double score;

  const _ScoredProduct(this.product, this.score);
}

_SearchResult _rankSearchResults(List<Product> products, String rawQuery) {
  final query = _normalize(rawQuery);

  if (query.isEmpty) {
    return const _SearchResult({});
  }

  final rankedCategories = <_ScoredCategory>[];

  for (final uiCategory in UiCategory.values) {
    final categoryTypes = categoryMap[uiCategory] ?? [];
    final categoryProducts = products
        .where((product) => categoryTypes.contains(product.category))
        .toList();

    if (categoryProducts.isEmpty) {
      continue;
    }

    final categoryScore = _categoryScore(uiCategory, categoryTypes, query);
    final scoredProducts = <_ScoredProduct>[];

    for (final product in categoryProducts) {
      final productScore = _productScore(product, uiCategory, query);
      final includeFromCategoryMatch = categoryScore >= 65;

      if (productScore >= 36 || includeFromCategoryMatch) {
        scoredProducts.add(
          _ScoredProduct(product, productScore + categoryScore * 0.22),
        );
      }
    }

    if (scoredProducts.isEmpty) {
      continue;
    }

    scoredProducts.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) {
        return scoreComparison;
      }
      return a.product.name.compareTo(b.product.name);
    });

    final topScore = scoredProducts.first.score;
    final topThreeAverage =
        scoredProducts
            .take(3)
            .fold<double>(0, (sum, item) => sum + item.score) /
        scoredProducts.take(3).length;

    rankedCategories.add(
      _ScoredCategory(
        uiCategory,
        scoredProducts,
        categoryScore * 4 + topScore + topThreeAverage,
      ),
    );
  }

  rankedCategories.sort((a, b) {
    final scoreComparison = b.score.compareTo(a.score);
    if (scoreComparison != 0) {
      return scoreComparison;
    }
    return a.category.label.compareTo(b.category.label);
  });

  return _SearchResult({
    for (final category in rankedCategories)
      category.category: category.products.map((item) => item.product).toList(),
  });
}

double _productScore(Product product, UiCategory uiCategory, String query) {
  final productCategoryLabel = _productCategoryLabels[product.category] ?? "";

  return _textScore(product.name, query) * 3.2 +
      _textScore(productCategoryLabel, query) * 1.6 +
      _textScore(uiCategory.label, query) * 1.2;
}

double _categoryScore(
  UiCategory uiCategory,
  List<ProductCategory> productCategories,
  String query,
) {
  var score = _textScore(uiCategory.label, query);

  for (final category in productCategories) {
    final categoryLabel = _productCategoryLabels[category] ?? "";
    final nextScore = _textScore(categoryLabel, query);
    if (nextScore > score) {
      score = nextScore;
    }
  }

  return score;
}

double _textScore(String rawText, String query) {
  final text = _normalize(rawText);

  if (text.isEmpty || query.isEmpty) {
    return 0;
  }

  if (text == query) {
    return 120;
  }

  final words = text.split(' ').where((word) => word.isNotEmpty).toList();

  if (words.contains(query)) {
    return 108;
  }

  if (text.startsWith(query)) {
    return 96;
  }

  if (words.any((word) => word.startsWith(query))) {
    return 88;
  }

  final containsIndex = text.indexOf(query);
  if (containsIndex >= 0) {
    final latePenalty = containsIndex * 0.8;
    final score = 76 - latePenalty;
    return score < 48 ? 48 : score;
  }

  if (query.length >= 3) {
    final fuzzyScore = _bestFuzzyWordScore(words, query);
    if (fuzzyScore > 0) {
      return fuzzyScore;
    }
  }

  if (query.length >= 2 && _isSubsequence(query, text)) {
    return 32;
  }

  return 0;
}

double _bestFuzzyWordScore(List<String> words, String query) {
  var bestScore = 0.0;

  for (final word in words) {
    if ((word.length - query.length).abs() > 2) {
      continue;
    }

    final distance = _levenshtein(word, query);
    if (distance > 2) {
      continue;
    }

    final score = 72 - distance * 12;
    if (score > bestScore) {
      bestScore = score.toDouble();
    }
  }

  return bestScore;
}

bool _isSubsequence(String query, String text) {
  var queryIndex = 0;

  for (var i = 0; i < text.length; i++) {
    if (text[i] == query[queryIndex]) {
      queryIndex++;

      if (queryIndex == query.length) {
        return true;
      }
    }
  }

  return false;
}

int _levenshtein(String a, String b) {
  final previous = List<int>.generate(b.length + 1, (index) => index);
  final current = List<int>.filled(b.length + 1, 0);

  for (var i = 0; i < a.length; i++) {
    current[0] = i + 1;

    for (var j = 0; j < b.length; j++) {
      final insertCost = current[j] + 1;
      final deleteCost = previous[j + 1] + 1;
      final replaceCost = previous[j] + (a[i] == b[j] ? 0 : 1);

      current[j + 1] = [
        insertCost,
        deleteCost,
        replaceCost,
      ].reduce((value, element) => value < element ? value : element);
    }

    for (var j = 0; j < previous.length; j++) {
      previous[j] = current[j];
    }
  }

  return previous[b.length];
}

String _normalize(String value) {
  return value
      .toLowerCase()
      .replaceAll('å', 'a')
      .replaceAll('ä', 'a')
      .replaceAll('ö', 'o')
      .replaceAll('é', 'e')
      .replaceAll('&', ' ')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

const Map<ProductCategory, String> _productCategoryLabels = {
  ProductCategory.POD: "Baljväxter",
  ProductCategory.BREAD: "Bröd",
  ProductCategory.BERRY: "Bär",
  ProductCategory.CITRUS_FRUIT: "Citrusfrukter",
  ProductCategory.HOT_DRINKS: "Varma drycker",
  ProductCategory.COLD_DRINKS: "Kalla drycker",
  ProductCategory.EXOTIC_FRUIT: "Exotisk frukt",
  ProductCategory.FISH: "Fisk",
  ProductCategory.VEGETABLE_FRUIT: "Grönsaker Frukt & Grönt",
  ProductCategory.CABBAGE: "Kål",
  ProductCategory.MEAT: "Kött",
  ProductCategory.DAIRIES: "Mejeri Ägg Mjölk Ost Yoghurt",
  ProductCategory.MELONS: "Meloner",
  ProductCategory.FLOUR_SUGAR_SALT: "Mjöl Socker Salt",
  ProductCategory.NUTS_AND_SEEDS: "Nötter Frön",
  ProductCategory.PASTA: "Pasta",
  ProductCategory.POTATO_RICE: "Potatis Ris",
  ProductCategory.ROOT_VEGETABLE: "Rotfrukter",
  ProductCategory.FRUIT: "Frukt",
  ProductCategory.SWEET: "Sötsaker Snacks",
  ProductCategory.HERB: "Örter",
};

import 'package:flutter/material.dart';

// Denna fil innehåller datamodellen för produktkategorier.
// Här finns en enum med alla kategorier från backend,
// samt en klass som beskriver varje kategori med namn och ikon.
// Håller kategoridata på ett strukturerat sätt.

enum ProductCategory {
  MELONS,
  FLOUR_SUGAR_SALT,
  MEAT,
  DAIRIES,
  VEGETABLE_FRUIT,
  CABBAGE,
  NUTS_AND_SEEDS,
  PASTA,
  POTATO_RICE,
  ROOT_VEGETABLE,
  FRUIT,
  SWEET,
  HERB,
  POD,
  BREAD,
  BERRY,
  CITRUS_FRUIT,
  HOT_DRINKS,
  COLD_DRINKS,
  EXOTIC_FRUIT,
  FISH,
}


class Category {
  final ProductCategory category;
  final String label;
  final IconData? icon;      // 
  final String? iconPath;    // 
  final String? bgImagePath; // 

  const Category({
    required this.category,
    required this.label,
    this.icon,
    this.iconPath,
    this.bgImagePath,
  });
}

import 'package:imat_repo/model/imat/product.dart';

enum UiCategory {
  fruktOchGront,
  kottOchFisk,
  mejeriAgg,
  torrvaror,
  brod,
  snacks,
  dryck,
}

extension UiCategoryLabel on UiCategory {
  String get label {
    switch (this) {
      case UiCategory.fruktOchGront:
        return "Frukt & Grönt";
      case UiCategory.kottOchFisk:
        return "Kött & Fisk";
      case UiCategory.mejeriAgg:
        return "Mejeri & Ägg";
      case UiCategory.torrvaror:
        return "Torrvaror";
      case UiCategory.brod:
        return "Bröd";
      case UiCategory.snacks:
        return "Snacks & Sötsaker";
      case UiCategory.dryck:
        return "Drycker";
    }
  }
}

Map<UiCategory, List<ProductCategory>> categoryMap = {
  UiCategory.fruktOchGront: [
    ProductCategory.VEGETABLE_FRUIT,
    ProductCategory.ROOT_VEGETABLE,
    ProductCategory.CITRUS_FRUIT,
    ProductCategory.EXOTIC_FRUIT,
    ProductCategory.BERRY,
    ProductCategory.MELONS,
    ProductCategory.CABBAGE,
    ProductCategory.HERB,
  ],
  UiCategory.kottOchFisk: [
    ProductCategory.MEAT,
    ProductCategory.FISH,
  ],
  UiCategory.mejeriAgg: [
    ProductCategory.DAIRIES,
  ],
  UiCategory.torrvaror: [
    ProductCategory.FLOUR_SUGAR_SALT,
    ProductCategory.PASTA,
    ProductCategory.POD,
    ProductCategory.POTATO_RICE,
    ProductCategory.NUTS_AND_SEEDS,
  ],
  UiCategory.brod: [
    ProductCategory.BREAD,
  ],
  UiCategory.snacks: [
    ProductCategory.SWEET,
  ],
  UiCategory.dryck: [
    ProductCategory.COLD_DRINKS,
    ProductCategory.HOT_DRINKS,
  ],
};

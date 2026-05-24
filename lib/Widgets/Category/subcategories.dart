import 'package:imat_repo/model/imat/product.dart';
import 'ui_categories.dart';

class _SubCategoryGroup {
  final String title;
  final List<ProductCategory> categories;

  const _SubCategoryGroup(this.title, this.categories);
}

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

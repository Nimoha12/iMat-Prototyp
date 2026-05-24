import 'package:imat_repo/model/imat/product.dart';
import 'ui_categories.dart';

extension ProductUiCategory on Product {
  UiCategory get uiCategory {
    for (final entry in categoryMap.entries) {
      if (entry.value.contains(category)) {
        return entry.key;
      }
    }
    return UiCategory.fruktOchGront;
  }
}

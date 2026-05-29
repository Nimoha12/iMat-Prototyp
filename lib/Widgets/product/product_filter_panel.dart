import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_buttons.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import '../Category/ui_categories.dart';
import '../Category/subcategories.dart';
import 'filter_selection.dart';

enum EcoFilter { alla, eco, inteEco }

/// Default filter values used when clearing filters.
class ProductFilterDefaults {
  static const double maxPrice = 200;
  static const EcoFilter ecoFilter = EcoFilter.alla;
  static const String sortBy = 'none';
  static const FilterSelection selection = FilterSelection();
}

class ProductFilterPanel extends StatelessWidget {
  final double maxPrice;
  final Function(double) onPriceChange;

  final EcoFilter ecoFilter;
  final Function(EcoFilter) onEcoChange;

  final String sortBy;
  final Function(String) onSortChange;

  final FilterSelection selection;
  final ValueChanged<FilterSelection> onSelectionChanged;

  final UiCategory? contextCategory;

  final VoidCallback onClose;
  final VoidCallback onApplyFilters;
  final VoidCallback onClearFilters;

  final bool showCategoryFilter;

  const ProductFilterPanel({
    super.key,
    required this.maxPrice,
    required this.onPriceChange,
    required this.ecoFilter,
    required this.onEcoChange,
    required this.sortBy,
    required this.onSortChange,
    required this.selection,
    required this.onSelectionChanged,
    required this.onClose,
    required this.onApplyFilters,
    required this.onClearFilters,
    this.contextCategory,
    this.showCategoryFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: IMatColors.white,
      child: SizedBox(
        width: 430,
        height: double.infinity,
        child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 38),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maxpris: ${maxPrice.toInt()} kr',
                      style: IMatText.bodyM.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 8),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Transform.translate(
                        offset: const Offset(-8, 0),
                        child: Slider(
                          value: maxPrice,
                          min: 0,
                          max: ProductFilterDefaults.maxPrice,
                          divisions: 8,
                          activeColor: IMatColors.green,
                          onChanged: onPriceChange,
                        ),
                      ),
                    ),

                    const Divider(height: 40),

                    Text(
                      'Ekologiskt',
                      style: IMatText.bodyM.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        _ecoChip(
                          label: 'Alla',
                          selected: ecoFilter == EcoFilter.alla,
                          onTap: () => onEcoChange(EcoFilter.alla),
                        ),
                        const SizedBox(width: 8),
                        _ecoChip(
                          label: 'Ekologiskt',
                          selected: ecoFilter == EcoFilter.eco,
                          onTap: () => onEcoChange(EcoFilter.eco),
                        ),
                        const SizedBox(width: 8),
                        _ecoChip(
                          label: 'Ej ekologiskt',
                          selected: ecoFilter == EcoFilter.inteEco,
                          onTap: () => onEcoChange(EcoFilter.inteEco),
                        ),
                      ],
                    ),

                    const Divider(height: 40),

                    Text(
                      'Sortera',
                      style: IMatText.bodyM.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: sortBy,
                      iconSize: 26,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: IMatColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: IMatColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: IMatColors.green,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: IMatText.bodyM.copyWith(
                        fontSize: 16,
                        color: IMatColors.black,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'none',
                          child: Text(
                            'Ingen sortering',
                            style: IMatText.bodyM.copyWith(fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'priceAsc',
                          child: Text(
                            'Pris: Lågt till högt',
                            style: IMatText.bodyM.copyWith(fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'priceDesc',
                          child: Text(
                            'Pris: Högt till lågt',
                            style: IMatText.bodyM.copyWith(fontSize: 16),
                          ),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) onSortChange(v);
                      },
                    ),

                    if (showCategoryFilter) ...[
                      const Divider(height: 40),
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: EdgeInsets.zero,
                          title: Text(
                            'Välj kategori',
                            style: IMatText.bodyM.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          children: [
                            const SizedBox(height: 4),
                            if (contextCategory == null)
                              Column(
                                children: UiCategory.values.map((uiCat) {
                                  final isSelected = selection
                                      .selectedMainCategories
                                      .contains(uiCat);

                                  return CheckboxListTile(
                                    value: isSelected,
                                    dense: true,
                                    visualDensity: const VisualDensity(
                                      vertical: -2,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: IMatColors.green,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                      uiCat.label,
                                      style: IMatText.bodyM.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onChanged: (_) {
                                      onSelectionChanged(
                                        selection.toggleMain(uiCat),
                                      );
                                    },
                                  );
                                }).toList(),
                              )
                            else
                              Column(
                                children:
                                    (subCategoryGroups[contextCategory] ?? [])
                                        .map((g) {
                                  final isSelected = selection
                                      .selectedSubCategories
                                      .contains(g.title);

                                  return CheckboxListTile(
                                    value: isSelected,
                                    dense: true,
                                    visualDensity: const VisualDensity(
                                      vertical: -2,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: IMatColors.green,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                      g.title,
                                      style: IMatText.bodyM.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onChanged: (_) {
                                      onSelectionChanged(
                                        selection.toggleSub(g.title),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      style: IMatButton.primaryGreen,
                      onPressed: onApplyFilters,
                      child: const Text('Visa resultat'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: OutlinedButton(
                      style: IMatButton.outlinedRed,
                      onPressed: onClearFilters,
                      child: const Text('Rensa filter'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _ecoChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? IMatColors.green : IMatColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? IMatColors.green : IMatColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: IMatText.bodyS.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? IMatColors.white : IMatColors.black,
            height: 1,
          ),
        ),
      ),
    );
  }
}

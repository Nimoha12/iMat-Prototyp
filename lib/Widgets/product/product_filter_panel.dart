import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import '../Category/ui_categories.dart';
import '../Category/subcategories.dart';
import 'filter_selection.dart';

enum EcoFilter { alla, eco, inteEco }

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

  final bool fullHeight;
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
    this.contextCategory,
    this.fullHeight = false,
    this.showCategoryFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: fullHeight
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(-4, 0),
                ),
              ]
            : null,
      ),
      child: Material(
        color: IMatColors.white,
        child: Container(
          width: 360,
          height: fullHeight ? double.infinity : null,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter",
                      style: IMatText.h3.copyWith(fontSize: 24),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 26,
                      onPressed: onClose,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // PRIS
                Text(
                  "Maxpris: ${maxPrice.toInt()} kr",
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
                      max: 200,
                      divisions: 8,
                      activeColor: IMatColors.green,
                      onChanged: onPriceChange,
                    ),
                  ),
                ),

                const Divider(height: 40),

                // EKOLOGISKT
                Text(
                  "Ekologiskt",
                  style: IMatText.bodyM.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    _ecoChip(
                      label: "Alla",
                      selected: ecoFilter == EcoFilter.alla,
                      onTap: () => onEcoChange(EcoFilter.alla),
                    ),

                    const SizedBox(width: 8),

                    _ecoChip(
                      label: "Ekologiskt",
                      selected: ecoFilter == EcoFilter.eco,
                      onTap: () => onEcoChange(EcoFilter.eco),
                    ),

                    const SizedBox(width: 8),

                    _ecoChip(
                      label: "Ej ekologiskt",
                      selected: ecoFilter == EcoFilter.inteEco,
                      onTap: () => onEcoChange(EcoFilter.inteEco),
                    ),
                  ],
                ),

                const Divider(height: 40),

                // SORTERA
                Text(
                  "Sortera",
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
                      value: "none",
                      child: Text(
                        "Ingen sortering",
                        style: IMatText.bodyM.copyWith(fontSize: 16),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "priceAsc",
                      child: Text(
                        "Pris: Lågt till högt",
                        style: IMatText.bodyM.copyWith(fontSize: 16),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "priceDesc",
                      child: Text(
                        "Pris: Högt till lågt",
                        style: IMatText.bodyM.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) onSortChange(v);
                  },
                ),

                // KATEGORI
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
                        "Välj kategori",
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

                const SizedBox(height: 36),

                // APPLY BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onApplyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: IMatColors.green,
                      foregroundColor: IMatColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Visa resultat",
                      style: IMatText.bodyM.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: IMatColors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
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
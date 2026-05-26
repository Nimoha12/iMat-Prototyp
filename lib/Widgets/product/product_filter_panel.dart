import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import '../Category/ui_categories.dart';

enum EcoFilter { alla, eco, inteEco }

class ProductFilterPanel extends StatelessWidget {
  final double maxPrice;
  final Function(double) onPriceChange;

  final EcoFilter ecoFilter;
  final Function(EcoFilter) onEcoChange;

  final String sortBy;
  final Function(String) onSortChange;

  final UiCategory? selectedCategory;
  final Function(UiCategory?) onCategoryChange;

  final VoidCallback onClose;

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
    required this.selectedCategory,
    required this.onCategoryChange,
    required this.onClose,
    this.fullHeight = false,
    this.showCategoryFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: fullHeight ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IMatColors.white,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Filter", style: IMatText.h3),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),

            const SizedBox(height: 24),

            //pris

            Text(
              "Maxpris: ${maxPrice.toInt()} kr",
              style: IMatText.bodyM.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Slider(
              value: maxPrice,
              min: 0,
              max: 200,
              divisions: 8,
              activeColor: IMatColors.green,
              onChanged: onPriceChange,
            ),

            const Divider(height: 40),

            //ekologiskt

            Text(
              "Ekologiskt",
              style: IMatText.bodyM.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            SegmentedButton<EcoFilter>(
              segments: const [
                ButtonSegment(
                  value: EcoFilter.alla,
                  label: Text("Alla"),
                ),
                ButtonSegment(
                  value: EcoFilter.eco,
                  label: Text("Ekologiskt"),
                ),
                ButtonSegment(
                  value: EcoFilter.inteEco,
                  label: Text("Ej ekologiskt"),
                ),
              ],
              selected: {ecoFilter},
              onSelectionChanged: (v) => onEcoChange(v.first),
            ),

            const Divider(height: 40),

           //Sortera

            Text(
              "Sortera",
              style: IMatText.bodyM.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: sortBy,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "none",
                  child: Text("Ingen sortering"),
                ),
                DropdownMenuItem(
                  value: "priceAsc",
                  child: Text("Pris: Lågt till högt"),
                ),
                DropdownMenuItem(
                  value: "priceDesc",
                  child: Text("Pris: Högt till lågt"),
                ),
              ],
              onChanged: (v) => onSortChange(v!),
            ),
            //kategori

            if (showCategoryFilter) ...[
              const Divider(height: 40),

              Text(
                "Kategori",
                style: IMatText.bodyM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Column(
                children: UiCategory.values.map((uiCat) {
                  final isSelected = selectedCategory == uiCat;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? IMatColors.green.withOpacity(0.08)
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      title: Text(
                        uiCat.label,
                        style: IMatText.bodyM,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: IMatColors.green,
                            )
                          : null,
                      onTap: () =>
                          onCategoryChange(isSelected ? null : uiCat),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
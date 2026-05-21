import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'ui_categories.dart';

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

  final bool fullHeight; // <-- NYTT

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
    this.fullHeight = false, // <-- DEFAULT = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: fullHeight ? double.infinity : null, // <-- FIX
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

            Text("Kategori", style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            Column(
              children: UiCategory.values.map((uiCat) {
                final isSelected = selectedCategory == uiCat;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(uiCat.label, style: IMatText.bodyM),
                  trailing: isSelected
                      ? Icon(Icons.check, color: IMatColors.green)
                      : null,
                  onTap: () => onCategoryChange(isSelected ? null : uiCat),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            Text("Maxpris: ${maxPrice.toInt()} kr",
                style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w600)),
            Slider(
              value: maxPrice,
              min: 0,
              max: 200,
              divisions: 8,
              activeColor: IMatColors.green,
              onChanged: onPriceChange,
            ),

            const SizedBox(height: 24),

            Text("Ekologiskt",
                style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            SegmentedButton<EcoFilter>(
              segments: const [
                ButtonSegment(value: EcoFilter.alla, label: Text("Alla")),
                ButtonSegment(value: EcoFilter.eco, label: Text("Ekologiskt")),
                ButtonSegment(value: EcoFilter.inteEco, label: Text("Ej ekologiskt")),
              ],
              selected: {ecoFilter},
              onSelectionChanged: (v) => onEcoChange(v.first),
            ),

            const SizedBox(height: 24),

            Text("Sortera",
                style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: sortBy,
              items: const [
                DropdownMenuItem(value: "none", child: Text("Ingen sortering")),
                DropdownMenuItem(value: "priceAsc", child: Text("Pris: Lågt till högt")),
                DropdownMenuItem(value: "priceDesc", child: Text("Pris: Högt till lågt")),
              ],
              onChanged: (v) => onSortChange(v!),
            ),
          ],
        ),
      ),
    );
  }
}

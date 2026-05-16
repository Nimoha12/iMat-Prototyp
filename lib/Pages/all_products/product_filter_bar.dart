import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';

enum EcoFilter { alla, eco, inteEco }

class ProductFilterBar extends StatelessWidget {
  final double maxPrice;
  final Function(double) onPriceChange;

  final EcoFilter ecoFilter;
  final Function(EcoFilter) onEcoChange;

  final String sortBy;
  final Function(String) onSortChange;

  const ProductFilterBar({
    super.key,
    required this.maxPrice,
    required this.onPriceChange,
    required this.ecoFilter,
    required this.onEcoChange,
    required this.sortBy,
    required this.onSortChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // kompaktare padding och rundning
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IMatColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IMatColors.border),
      ),
      constraints: const BoxConstraints(maxWidth: 600), // begränsa bredd
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Filter & sortering", style: IMatText.h3),
          const SizedBox(height: 16),

          Text(
            "Maxpris: ${maxPrice.toInt()} kr",
            style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Text("0 kr",
                  style: IMatText.bodyS.copyWith(
                      color: IMatColors.textSecondary)),
              Expanded(
                child: Slider(
                  value: maxPrice,
                  min: 0,
                  max: 200,
                  divisions: 8,
                  activeColor: IMatColors.green,
                  onChanged: onPriceChange,
                ),
              ),
              Text("200 kr",
                  style: IMatText.bodyS.copyWith(
                      color: IMatColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),

          Text("Ekologiskt",
              style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          SegmentedButton<EcoFilter>(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return IMatColors.green;
                }
                return IMatColors.greenLight; // konsekvent ljusgrön bakgrund
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return IMatColors.white;
                }
                return IMatColors.green;
              }),
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 10, horizontal: 14)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
            ),
            segments: const [
              ButtonSegment(value: EcoFilter.alla, label: Text("Alla")),
              ButtonSegment(value: EcoFilter.eco, label: Text("Ekologiskt")),
              ButtonSegment(value: EcoFilter.inteEco, label: Text("Ej ekologiskt")),
            ],
            selected: {ecoFilter},
            onSelectionChanged: (newValue) => onEcoChange(newValue.first),
          ),
          const SizedBox(height: 16),

          Text("Sortera",
              style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: sortBy,
            decoration: InputDecoration(
              filled: true,
              fillColor: IMatColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
            items: const [
              DropdownMenuItem(value: "none", child: Text("Ingen sortering")),
              DropdownMenuItem(value: "priceAsc", child: Text("Pris: Lågt till högt")),
              DropdownMenuItem(value: "priceDesc", child: Text("Pris: Högt till lågt")),
            ],
            onChanged: (v) => onSortChange(v!),
          ),
        ],
      ),
    );
  }
}

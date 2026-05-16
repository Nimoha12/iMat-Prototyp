import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'ui_categories.dart';

class CategoryFilterBar extends StatelessWidget {
  final UiCategory? selected;
  final void Function(UiCategory?) onSelect;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: UiCategory.values.map((uiCat) {
        final isSelected = selected == uiCat;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onSelect(isSelected ? null : uiCat),
          child: Ink(
            decoration: BoxDecoration(
              color: isSelected
                  ? IMatColors.green
                  : IMatColors.greenLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? IMatColors.green
                    : IMatColors.border,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              child: Text(
                uiCat.label,
                style: IMatText.bodyM.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? IMatColors.white
                      : IMatColors.green,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
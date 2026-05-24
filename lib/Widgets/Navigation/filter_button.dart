import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FilterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Filterknapp – gemensam för alla sidor
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // placerar knappen längst till höger
      children: [
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(Icons.filter_list,
              color: IMatColors.green, size: 22),
          label: Text(
            "Filtrera bland varor",
            style: IMatText.bodyM.copyWith(
              fontWeight: FontWeight.w800,
              color: IMatColors.black,
              letterSpacing: 0.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: IMatColors.white,
            foregroundColor: IMatColors.black,
            elevation: 3,
            shadowColor: IMatColors.green.withOpacity(0.25),
            side: BorderSide(color: IMatColors.green, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ],
    );
  }
}

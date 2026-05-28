// ==========================
// NAV_ICON.DART
// ==========================

import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

class NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  const NavIcon({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        selected
            ? IMatColors.green
            : IMatColors.white;

    final textColor =
        selected
            ? IMatColors.green
            : IMatColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Material(
        color: selected
            ? IMatColors.greenLight
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: IMatColors.green.withOpacity(0.2),
          onTap: onTap,
          child: SizedBox(
            width: 108,
            height: 84,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 34,
                ),

                const SizedBox(height: 10),

                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.5,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
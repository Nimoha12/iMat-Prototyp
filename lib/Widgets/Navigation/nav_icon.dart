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
    // Förbättrad kontrast och tydlighet för äldre användare
    final iconColor = selected ? IMatColors.green : IMatColors.white;
    final textColor = selected ? IMatColors.greenHover : IMatColors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 95,
        decoration: BoxDecoration(
          color: selected
              ? IMatColors.navSelectedBackground
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 38,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

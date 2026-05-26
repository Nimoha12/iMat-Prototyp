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
        width: 120, // något bredare för luft
        height: 88, // högre för större ikon + text
        color: selected
            ? IMatColors.greenLight // ljus bakgrund vid val
            : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Större ikon för bättre synlighet
            Icon(
              icon,
              color: iconColor,
              size: 38, // tidigare 32
            ),
            const SizedBox(height: 10),
            // Större text med bättre kontrast
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 18, //
                letterSpacing: 0.3, // lite mer luft mellan bokstäver
              ),
            ),
          ],
        ),
      ),
    );
  }
}

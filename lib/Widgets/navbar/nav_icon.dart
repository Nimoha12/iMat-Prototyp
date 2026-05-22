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
    final iconColor = selected
        ? IMatColors.green
        : Colors.white;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 78,
        color: selected
            ? const Color(0xFFF6F3ED)
            : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // 🔹 Lägg till onTap här

  const NavIcon({
    super.key,
    required this.icon,
    required this.label,
    this.onTap, // 🔹 Gör parametern valfri
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 🔹 Gör ikonen klickbar
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

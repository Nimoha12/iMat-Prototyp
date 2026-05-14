import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/navbar/cart.button.dart';
import 'nav_icon.dart';
import 'logo.dart';

class IMatNavbar extends StatelessWidget implements PreferredSizeWidget {
  const IMatNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: IMatColors.green,
      elevation: 0,
      toolbarHeight: 70,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 16),

          // ⭐ Logga
          const IMatLogo(),
          const SizedBox(width: 24),

          // ⭐ Sökfält
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 40,
                child: TextField(
                  style: IMatText.bodyM,
                  decoration: InputDecoration(
                    hintText: "Sök varor...",
                    hintStyle: IMatText.bodyS.copyWith(color: Colors.grey),
                    filled: true,
                    fillColor: IMatColors.white,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ⭐ Ikoner
          const CartButton(),
          const NavIcon(icon: Icons.favorite_border, label: "Favoriter"),
          const NavIcon(icon: Icons.history, label: "Historik"),
          const NavIcon(icon: Icons.help_outline, label: "Hjälp"),
          const NavIcon(icon: Icons.person_outline, label: "Logga in"),

          const SizedBox(width: 12),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

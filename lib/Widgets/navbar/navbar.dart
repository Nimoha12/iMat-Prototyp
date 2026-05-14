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
      title: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxWidth < 900;

          return Row(
            children: [
              const SizedBox(width: 16),

              // Klickbar logga som leder till startsidan
              IMatLogo(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
              const SizedBox(width: 24),

              //  Kortare sökfält (mer luftigt)
              //  Kortare sökfält (mer luftigt)
              Expanded(
                flex: isSmallScreen ? 2 : 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ), // ✅ Begränsar maxbredden
                      child: SizedBox(
                        height: 38,
                        child: TextField(
                          style: IMatText.bodyM,
                          decoration: InputDecoration(
                            hintText: "Sök varor...",
                            hintStyle: IMatText.bodyS.copyWith(
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: IMatColors.white,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Ikoner (klickbara)
              CartButton(
                onTap: () {
                  // TODO: Navigera till varukorg
                },
              ),
              NavIcon(
                icon: Icons.favorite_border,
                label: "Favoriter",
                onTap: () {
                  // TODO: Navigera till favoriter
                },
              ),
              NavIcon(
                icon: Icons.history,
                label: "Historik",
                onTap: () {
                  // TODO: Navigera till historik
                },
              ),
              NavIcon(
                icon: Icons.help_outline,
                label: "Hjälp",
                onTap: () {
                  // TODO: Navigera till hjälp
                },
              ),
              NavIcon(
                icon: Icons.person_outline,
                label: "Logga in",
                onTap: () {
                  // TODO: Navigera till login
                },
              ),
              const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

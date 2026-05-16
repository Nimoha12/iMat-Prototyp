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
    final bool canGoBack =
    ModalRoute.of(context)?.settings.name != '/';

    return AppBar(
      backgroundColor: IMatColors.green,
      elevation: 0,
      toolbarHeight: 78,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxWidth < 900;

          return Row(
            children: [
              const SizedBox(width: 12),

              // Visa endast tillbaka-knapp om man kan gå tillbaka
              if (canGoBack)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 32,
                    ),
                    tooltip: "Tillbaka",
                  ),
                ),

              // Klickbar logga som leder till startsidan
              IMatLogo(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),

              const SizedBox(width: 24),

              // Kortare sökfält (mer luftigt)
              Expanded(
                flex: isSmallScreen ? 2 : 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 620,
                      ),
                      child: SizedBox(
                        height: 46,
                        child: TextField(
                          style: IMatText.bodyM,
                          decoration: InputDecoration(
                            hintText: "Sök varor...",
                            hintStyle: IMatText.bodyM.copyWith(
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: IMatColors.white,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 28,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Ikoner
              CartButton(
                onTap: () {
                  // TODO: Navigera till varukorg
                },
              ),

              NavIcon(
                icon: Icons.favorite_border,
                label: "Favoriter",
                onTap: () {},
              ),

              NavIcon(
                icon: Icons.history,
                label: "Historik",
                onTap: () {},
              ),

              NavIcon(
                icon: Icons.help_outline,
                label: "Hjälp",
                onTap: () {},
              ),

              NavIcon(
                icon: Icons.person_outline,
                label: "Logga in",
                onTap: () {},
              ),

              const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(78);
}
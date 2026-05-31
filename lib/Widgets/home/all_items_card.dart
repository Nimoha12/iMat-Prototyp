import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/all_products/all_categories_page.dart';
import 'package:imat_repo/Theme/imat_theme.dart';

// Visar en informationsruta bredvid hero-sektionen.
// Anpassad för att matcha hero-sektionens höjd och layout.

class AllItemsCard extends StatefulWidget {
  const AllItemsCard({super.key});

  @override
  State<AllItemsCard> createState() => _AllItemsCardState();
}

class _AllItemsCardState extends State<AllItemsCard> {
  bool _hovered = false; // hover state

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AllCategoriesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),

      child: GestureDetector(
        onTap: () => _onTap(context),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()..scale(_hovered ? 1.04 : 1.0),

          decoration: BoxDecoration(
            color: IMatColors.green,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: IMatColors.green,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.14 : 0.08),
                blurRadius: _hovered ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Alla varor",
                  style: IMatText.headingM.copyWith(
                    color: IMatColors.white,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  "Bläddra bland alla produkter i butiken.",
                  style: IMatText.bodyS.copyWith(
                    color: IMatColors.white,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  style: IMatButton.primary,
                  onPressed: () => _onTap(context),
                  child: const Text("Visa alla varor"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';

// Visar en informationsruta bredvid hero-sektionen.
// Anpassad för att matcha hero-sektionens höjd och layout.

class AllItemsCard extends StatelessWidget {
  const AllItemsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IMatColors.green,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: IMatColors.green,
          width: 1.5,
        ),
      ),
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
            onPressed: () {},
            child: const Text("Visa alla varor"),
          ),
        ],
      ),
    );
  }
}
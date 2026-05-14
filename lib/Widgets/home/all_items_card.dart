import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';

class AllItemsCard extends StatelessWidget {
  const AllItemsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IMatColors.accent,
        borderRadius: BorderRadius.circular(12),
        border : Border.all(
          color: IMatColors.accent,
          width: 1.5
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Alla varor", style: IMatText.headingM),
          const SizedBox(height: 12),
          Text("Bläddra bland alla produkter i butiken.",
              style: IMatText.bodyS),
          const SizedBox(height: 24),
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

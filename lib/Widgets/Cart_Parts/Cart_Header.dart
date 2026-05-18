import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {

  final VoidCallback onClose;

  const CartHeader({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          const Text(
            "Varukorg",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),

          IconButton(
            onPressed: onClose,

            icon: const Icon(
              Icons.close,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 24),

          Text(
            "Din varukorg är tom",
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
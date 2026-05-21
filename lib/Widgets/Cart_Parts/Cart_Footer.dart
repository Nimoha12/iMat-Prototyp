import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/checkout_page.dart';
import 'package:imat_repo/model/imat_data_handler.dart';

import 'package:provider/provider.dart';

class CartFooter extends StatelessWidget {
  const CartFooter({super.key});

  @override
  Widget build(BuildContext context) {
    var iMatHandler = context.watch<ImatDataHandler>();
    
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              const Text(
                "Totalt:",
                style: TextStyle(fontSize: 22),
              ),

              Text(
                "${iMatHandler.shoppingCartTotal()} kr",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 64,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),

              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    settings: const RouteSettings(name: '/checkout'),
                    builder: (_) => const CheckoutPage(),
                  ),
                );
              },

              child: const Text(
                "Gå till checkout",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 58,

            child: OutlinedButton(
              onPressed: () {iMatHandler.shoppingCartClear();},

              child: const Text(
                "Töm varukorg",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Cart_Parts/Cart.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    var iMatHandler = context.watch<ImatDataHandler>();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7EA79A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      onPressed: () {

        Navigator.push(
          context,

          PageRouteBuilder(
            opaque: false,

            pageBuilder: (_, _, _) => const Cart(),
          ),
        );
      },

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Stack(
            clipBehavior: Clip.none,
            children: [

              const Icon(Icons.shopping_cart_outlined),

              Positioned(
                right: -6,
                top: -6,

                child: Container(
                  padding: const EdgeInsets.all(4),

                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  
                  child: Text(
                    "${iMatHandler.getShoppingCart().items.length}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          const Text("Varukorg"),
        ],
      ),
    );
  }
}
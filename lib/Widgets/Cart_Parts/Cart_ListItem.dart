import 'package:flutter/material.dart';
import 'package:imat_repo/model/imat/shopping_item.dart';

import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class CartListItem extends StatelessWidget {

  final ShoppingItem item;

  const CartListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    var iMatHandler =
        context.watch<ImatDataHandler>();

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // IMAGE
              SizedBox(
                width: 65,
                height: 65,

                child: iMatHandler.getImage(
                  item.product,
                ),
              ),

              const SizedBox(width: 16),

              // PRODUCT INFO
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      item.product.name,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${item.product.price.toStringAsFixed(2)} kr / ${item.product.unit}",

                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // DELETE BUTTON
              IconButton(
                onPressed: () {iMatHandler.shoppingCartRemove(item);},

                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFFD86464),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [

              // MINUS
              _circleButton(
                icon: Icons.remove,
                onPressed: (){iMatHandler.shoppingCartUpdate(item, delta: -1,);}
              ),

              const SizedBox(width: 18),

              // AMOUNT
              Text(
                item.amount.toInt().toString(),

                style: const TextStyle(
                  fontSize: 22,
                ),
              ),

              const SizedBox(width: 18),

              // PLUS
              _circleButton(
                icon: Icons.add,
                onPressed: (){iMatHandler.shoppingCartUpdate(item, delta: 1,);}
              ),

              const Spacer(),

              // TOTAL PRICE
              Text(
                "${(item.product.price * item.amount).toStringAsFixed(2)} kr",

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _circleButton({
  required IconData icon,
  required VoidCallback onPressed,
}) {

  return Material(
    color: Colors.transparent,

    child: InkWell(
      onTap: onPressed,

      borderRadius: BorderRadius.circular(100),

      child: Ink(
        width: 46,
        height: 46,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Icon(
          icon,
          size: 30,
          color: Colors.grey.shade700,
        ),
      ),
    ),
  );
}
}
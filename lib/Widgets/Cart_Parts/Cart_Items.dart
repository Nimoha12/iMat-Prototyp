import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Cart_Parts/Cart_ListItem.dart';

class CartItemsView extends StatelessWidget {

  final List cartItems;

  const CartItemsView({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding: const EdgeInsets.all(20),

      itemCount: cartItems.length,

      itemBuilder: (context, index) {

        return CartListItem(
          item: cartItems[index],
        );
      },
    );
  }
}
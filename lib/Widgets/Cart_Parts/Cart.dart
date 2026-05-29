import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Cart_Parts/Cart_Footer.dart';
import 'package:imat_repo/Widgets/Cart_Parts/Cart_Header.dart';
import 'package:imat_repo/Widgets/Cart_Parts/Cart_Items.dart';
import 'package:imat_repo/Widgets/Cart_Parts/Cart_empty.dart';
import 'package:imat_repo/model/imat_data_handler.dart';

import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  // TEMP CART DATA

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  Future<void> closeCart() async {
    await _controller.reverse();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var iMatHandler = context.watch<ImatDataHandler>();

    var cartItems = iMatHandler.getShoppingCart().items;

    return Material(
      color: Colors.black54,

      child: Stack(
        children: [
          // CLICK OUTSIDE
          GestureDetector(
            onTap: closeCart,

            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),

          // CART PANEL
          Align(
            alignment: Alignment.centerRight,

            child: SlideTransition(
              position: _slideAnimation,

              child: Container(
                width: 430,
                height: double.infinity,
                color: Colors.white,

                child: SafeArea(
                  child: Column(
                    children: [
                      CartHeader(onClose: closeCart),

                      const Divider(height: 1),

                      // CONDITIONAL LAYOUT
                      Expanded(
                        child: cartItems.isEmpty
                            ? const EmptyCartView()
                            : CartItemsView(cartItems: cartItems),
                      ),
                      if (cartItems.isNotEmpty ||
                          iMatHandler.canUndoShoppingCartClear)
                        const CartFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

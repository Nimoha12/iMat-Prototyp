import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/checkout_page.dart';
import 'package:imat_repo/Theme/imat_buttons.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class CartFooter extends StatefulWidget {
  const CartFooter({super.key});

  @override
  State<CartFooter> createState() => _CartFooterState();
}

class _CartFooterState extends State<CartFooter> {
  bool _showClearConfirmation = false;

  @override
  Widget build(BuildContext context) {
    var iMatHandler = context.watch<ImatDataHandler>();
    final total = iMatHandler.shoppingCartTotal(); // hämtar totalen
    final cartIsEmpty = iMatHandler.getShoppingCart().items.isEmpty;
    final canUndoClear = iMatHandler.canUndoShoppingCartClear;

    if (cartIsEmpty && _showClearConfirmation) {
      _showClearConfirmation = false;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          // Rad med totalbelopp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Totalt:", style: TextStyle(fontSize: 22)),
              Text(
                "${total.toStringAsFixed(2)} kr", // avrundar till 2 decimaler
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          if (canUndoClear)
            SizedBox(
              width: double.infinity,
              height: 62,
              child: OutlinedButton(
                onPressed: iMatHandler.shoppingCartUndoClear,
                style: IMatButton.outlinedGreen,
                child: const Text('Ångra'),
              ),
            )
          else if (!cartIsEmpty)
            _ClearCartButton(
              isExpanded: _showClearConfirmation,
              onToggle: () {
                setState(() {
                  _showClearConfirmation = true;
                });
              },
              onCancel: () {
                setState(() {
                  _showClearConfirmation = false;
                });
              },
              onClear: () {
                iMatHandler.shoppingCartClear();
                setState(() {
                  _showClearConfirmation = false;
                });
              },
            ),

          if (!cartIsEmpty && !_showClearConfirmation) ...[
            const SizedBox(height: 18),
            // Checkout-knapp
            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton(
                style: IMatButton.primaryGreen,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      settings: const RouteSettings(name: '/checkout'),
                      builder: (_) => const CheckoutPage(),
                    ),
                  );
                },
                child: const Text('Gå till checkout'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ClearCartButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onCancel;
  final VoidCallback onClear;

  const _ClearCartButton({
    required this.isExpanded,
    required this.onToggle,
    required this.onCancel,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final outlineColor = Colors.green.shade700;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: double.infinity,
      height: isExpanded ? 136 : 62,
      decoration: BoxDecoration(
        border: Border.all(color: outlineColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isExpanded ? null : onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Töm varukorg',
                  style: TextStyle(
                    color: outlineColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: isExpanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade700,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: onClear,
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text('Töm'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    style: IMatButton.outlinedGreen,
                                    onPressed: onCancel,
                                    child: const Text('Avbryt'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

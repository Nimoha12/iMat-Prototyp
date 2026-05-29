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
    final total = iMatHandler.shoppingCartTotal();
    final cartIsEmpty = iMatHandler.getShoppingCart().items.isEmpty;

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
          if (!cartIsEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Totalt:', style: TextStyle(fontSize: 22)),
                Text(
                  '${total.toStringAsFixed(2)} kr',
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
            const SizedBox(height: 18),
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
    if (!isExpanded) {
      return SizedBox(
        width: double.infinity,
        height: 62,
        child: OutlinedButton(
          style: IMatButton.outlinedRed,
          onPressed: onToggle,
          child: const Text('Töm varukorg'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 62,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 62,
              child: OutlinedButton(
                style: IMatButton.outlinedRed,
                onPressed: onClear,
                child: const Text('Töm'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 62,
              child: OutlinedButton(
                style: IMatButton.outlinedGreen,
                onPressed: onCancel,
                child: const Text('Avbryt'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

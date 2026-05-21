import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';

import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat/product_detail.dart';
import 'package:imat_repo/model/imat/shopping_item.dart';
import 'package:imat_repo/model/imat_data_handler.dart';

class ProductDetailWidget extends StatelessWidget {
  final Product product;

  const ProductDetailWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    final ProductDetail? detail = iMat.getDetail(product);

    final shoppingItem = iMat.getShoppingCart().items.firstWhere(
      (item) => item.product == product,
      orElse: () => ShoppingItem(product, amount: 0),
    );

    final double amount = shoppingItem.amount;

    final unit = product.unit.replaceAll("kr/", "");

    final details = [
      _DetailData("Varumärke", detail?.brand),
      _DetailData("Ursprung", detail?.origin),
      _DetailData("Innehåll", detail?.contents),
      _DetailData("Beskrivning", detail?.description),
    ].where((item) => item.content != null && item.content!.trim().isNotEmpty);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 820;
        final content = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: IMatColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: IMatColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isNarrow ? double.infinity : 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: isNarrow ? 220 : 280,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: IMatColors.chipBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: iMat.getImage(product),
                        ),
                        const SizedBox(height: 16),
                        _cartControl(
                          amount: amount,
                          iMat: iMat,
                          product: product,
                          shoppingItem: shoppingItem,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isNarrow ? 0 : 32, height: isNarrow ? 24 : 0),
                  if (isNarrow)
                    _productInfo(
                      details: details,
                      unit: unit,
                      isNarrow: isNarrow,
                    )
                  else
                    Expanded(
                      child: _productInfo(
                        details: details,
                        unit: unit,
                        isNarrow: isNarrow,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

        if (isNarrow || constraints.maxHeight < 620) {
          return SingleChildScrollView(child: content);
        }

        return content;
      },
    );
  }

  Widget _productInfo({
    required Iterable<_DetailData> details,
    required String unit,
    required bool isNarrow,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: IMatText.h2.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            if (product.isEcological) ...[
              const SizedBox(width: 12),
              _ecoBadge(),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${product.price.toStringAsFixed(2)} kr/$unit",
              style: IMatText.h2.copyWith(
                color: IMatColors.green,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                product.unit,
                style: IMatText.bodyS.copyWith(color: IMatColors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: details
              .map(
                (item) => _detailTile(
                  title: item.title,
                  content: item.content!,
                  isNarrow: isNarrow,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _ecoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        "Ekologisk",
        style: IMatText.bodyS.copyWith(
          color: Colors.green.shade900,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _detailTile({
    required String title,
    required String content,
    required bool isNarrow,
  }) {
    return Container(
      width: isNarrow ? double.infinity : (title == "Beskrivning" ? 520 : 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IMatColors.chipBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: IMatColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: IMatText.bodyS.copyWith(
              fontWeight: FontWeight.w700,
              color: IMatColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(content, style: IMatText.bodyM.copyWith(height: 1.35)),
        ],
      ),
    );
  }

  Widget _cartControl({
    required double amount,
    required ImatDataHandler iMat,
    required Product product,
    required ShoppingItem shoppingItem,
  }) {
    if (amount <= 0) {
      return SizedBox(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: IMatColors.green,
            foregroundColor: IMatColors.white,
            elevation: 0,
            textStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
          },
          child: const Text("Lägg till"),
        ),
      );
    }

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: IMatColors.chipBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: IMatColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _amountButton(
            icon: Icons.remove,
            onPressed: () {
              iMat.shoppingCartUpdate(shoppingItem, delta: -1);
            },
          ),
          Text(
            amount.toStringAsFixed(0),
            style: IMatText.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          _amountButton(
            icon: Icons.add,
            onPressed: () {
              iMat.shoppingCartUpdate(shoppingItem, delta: 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _amountButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 44,
      height: 44,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: IMatColors.green,
          foregroundColor: IMatColors.white,
          elevation: 0,

          padding: EdgeInsets.zero,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        child: Icon(icon),
      ),
    );
  }
}

class _DetailData {
  final String title;
  final String? content;

  const _DetailData(this.title, this.content);
}

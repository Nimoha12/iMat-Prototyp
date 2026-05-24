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

    final unit = product.unit.replaceAll('kr/', '');

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 820;
        final bool shouldScroll = isNarrow || constraints.maxHeight < 760;

        final content = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Container(
                decoration: BoxDecoration(
                  color: IMatColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: IMatColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Flex(
                  direction: isNarrow ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: shouldScroll
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.stretch,
                  children: [
                    _ImagePanel(
                      productImage: iMat.getImage(product),
                      isNarrow: isNarrow,
                    ),
                    _SoftDivider(isNarrow: isNarrow),
                    if (isNarrow)
                      _productInfo(
                        detail: detail,
                        unit: unit,
                        amount: amount,
                        iMat: iMat,
                        shoppingItem: shoppingItem,
                        isNarrow: isNarrow,
                      )
                    else
                      Expanded(
                        child: _productInfo(
                          detail: detail,
                          unit: unit,
                          amount: amount,
                          iMat: iMat,
                          shoppingItem: shoppingItem,
                          isNarrow: isNarrow,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );

        if (shouldScroll) {
          return SingleChildScrollView(child: content);
        }

        return content;
      },
    );
  }

  Widget _productInfo({
    required ProductDetail? detail,
    required String unit,
    required double amount,
    required ImatDataHandler iMat,
    required ShoppingItem shoppingItem,
    required bool isNarrow,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            isNarrow ? 24 : 34,
            isNarrow ? 24 : 32,
            isNarrow ? 24 : 34,
            isNarrow ? 26 : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: IMatText.h1.copyWith(
                        fontSize: isNarrow ? 34 : 40,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                  ),
                  if (product.isEcological) ...[
                    const SizedBox(width: 12),
                    _ecoBadge(),
                  ],
                ],
              ),
              _ProductMeta(detail: detail),
              const SizedBox(height: 22),
              _PurchasePanel(
                price: product.price,
                unit: unit,
                isNarrow: isNarrow,
                cartControl: _cartControl(
                  amount: amount,
                  iMat: iMat,
                  product: product,
                  shoppingItem: shoppingItem,
                ),
              ),
              const SizedBox(height: 22),
              _DetailTabs(
                contents: detail?.contents,
                description: detail?.description,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ecoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        "Ekologisk",
        style: IMatText.bodyM.copyWith(
          color: Colors.green.shade900,
          fontWeight: FontWeight.w700,
        ),
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
            textStyle: IMatText.bodyL.copyWith(fontWeight: FontWeight.w800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
          },
          child: const Text('Lägg till'),
        ),
      );
    }

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: IMatColors.chipBackground,
        borderRadius: BorderRadius.circular(8),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon),
      ),
    );
  }
}

class _ProductMeta extends StatelessWidget {
  final ProductDetail? detail;

  const _ProductMeta({required this.detail});

  @override
  Widget build(BuildContext context) {
    final values = [
      detail?.brand,
      detail?.origin,
    ].where((value) => value != null && value.trim().isNotEmpty).toList();

    if (values.isEmpty) {
      return const SizedBox(height: 8);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        values.map((value) => value!).join('  /  '),
        style: IMatText.bodyL.copyWith(
          color: IMatColors.textSecondary,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}

class _PurchasePanel extends StatelessWidget {
  final double price;
  final String unit;
  final bool isNarrow;
  final Widget cartControl;

  const _PurchasePanel({
    required this.price,
    required this.unit,
    required this.isNarrow,
    required this.cartControl,
  });

  @override
  Widget build(BuildContext context) {
    final priceText = Text(
      '${price.toStringAsFixed(2)} kr/$unit',
      style: IMatText.h1.copyWith(
        color: IMatColors.green,
        fontSize: 36,
        fontWeight: FontWeight.w900,
      ),
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: IMatColors.greenLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: IMatColors.green.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [priceText, const SizedBox(height: 14), cartControl],
      ),
    );
  }
}

class _DetailTabs extends StatelessWidget {
  final String? contents;
  final String? description;

  const _DetailTabs({required this.contents, required this.description});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _DetailTabData('Innehåll', contents),
      _DetailTabData('Beskrivning', description),
    ].where((tab) => tab.content.trim().isNotEmpty).toList();

    if (tabs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: IMatColors.chipBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: IMatColors.border),
        ),
        child: Text(
          'Ingen extra produktinformation finns tillgänglig.',
          style: IMatText.bodyL.copyWith(color: IMatColors.textSecondary),
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Container(
        decoration: BoxDecoration(
          color: IMatColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: IMatColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: false,
              labelColor: IMatColors.green,
              unselectedLabelColor: IMatColors.textSecondary,
              indicator: BoxDecoration(
                color: IMatColors.greenLight,
                borderRadius: BorderRadius.circular(6),
              ),
              indicatorPadding: const EdgeInsets.all(6),
              labelStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w900),
              unselectedLabelStyle: IMatText.bodyM.copyWith(
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                for (final tab in tabs)
                  Tab(
                    height: 52,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(tab.title),
                    ),
                  ),
              ],
            ),
            const Divider(height: 1, color: IMatColors.border),
            SizedBox(
              height: 132,
              child: TabBarView(
                children: [
                  for (final tab in tabs)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        tab.content,
                        style: IMatText.bodyL.copyWith(height: 1.35),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePanel extends StatelessWidget {
  final Widget productImage;
  final bool isNarrow;

  const _ImagePanel({required this.productImage, required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isNarrow ? double.infinity : 430,
      height: isNarrow ? 280 : null,
      padding: EdgeInsets.all(isNarrow ? 26 : 36),
      color: IMatColors.white,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: isNarrow ? 260 : 330,
              height: isNarrow ? 260 : 330,
              child: productImage,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailTabData {
  final String title;
  final String content;

  _DetailTabData(this.title, String? content) : content = content?.trim() ?? '';
}

class _SoftDivider extends StatelessWidget {
  final bool isNarrow;

  const _SoftDivider({required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isNarrow ? double.infinity : 1,
      height: isNarrow ? 1 : null,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: IMatColors.border),
      ),
    );
  }
}

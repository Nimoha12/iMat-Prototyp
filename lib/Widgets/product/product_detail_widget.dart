import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/Cart_Parts/add_to_cart_button.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat/product_detail.dart';
import 'package:imat_repo/model/imat_data_handler.dart';

class ProductDetailWidget extends StatelessWidget {
  final Product product;

  const ProductDetailWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final detail = iMat.getDetail(product);
    final unit = product.unit.replaceAll('kr/', '');

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 760;
        final contentPadding = EdgeInsets.fromLTRB(
          isNarrow ? 22 : 38,
          isNarrow ? 76 : 42,
          isNarrow ? 22 : 38,
          34,
        );

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: contentPadding,
              child: isNarrow
                  ? _NarrowLayout(
                      product: product,
                      detail: detail,
                      unit: unit,
                      image: iMat.getImage(product),
                    )
                  : _WideLayout(
                      product: product,
                      detail: detail,
                      unit: unit,
                      image: iMat.getImage(product),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _WideLayout extends StatelessWidget {
  final Product product;
  final ProductDetail? detail;
  final String unit;
  final Widget image;

  const _WideLayout({
    required this.product,
    required this.detail,
    required this.unit,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _ImageSection(product: product, image: image),
        ),
        const SizedBox(width: 34),
        Container(width: 1, height: 520, color: IMatColors.border),
        const SizedBox(width: 40),
        Expanded(
          flex: 7,
          child: _InfoSection(product: product, detail: detail, unit: unit),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final Product product;
  final ProductDetail? detail;
  final String unit;
  final Widget image;

  const _NarrowLayout({
    required this.product,
    required this.detail,
    required this.unit,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ImageSection(product: product, image: image, compact: true),
        const SizedBox(height: 24),
        _InfoSection(product: product, detail: detail, unit: unit),
      ],
    );
  }
}

class _ImageSection extends StatelessWidget {
  final Product product;
  final Widget image;
  final bool compact;

  const _ImageSection({
    required this.product,
    required this.image,
    this.compact = false,
  });

  @override
Widget build(BuildContext context) {
  final size = compact ? 250.0 : 340.0;
  final iMat = context.watch<ImatDataHandler>();
  final isFavorite = iMat.isFavorite(product);

  return Semantics(
    image: true,
    label: 'Produktbild av ${product.name}',
    child: Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.contain,
                child: image,
              ),
            ),

            Positioned(
  top: -6,
  right: -6,
  child: GestureDetector(
    onTap: () {
      iMat.toggleFavorite(product);
    },
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        border: Border.all(
          color: isFavorite
              ? Colors.red
              : IMatColors.green,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isFavorite
            ? Icons.favorite
            : Icons.favorite_border,
        size: 30,
        color: isFavorite
            ? Colors.red
            : IMatColors.green,
      ),
    ),
  ),
),
          ],
        ),
      ),
    ),
  );
}
}

class _InfoSection extends StatelessWidget {
  final Product product;
  final ProductDetail? detail;
  final String unit;

  const _InfoSection({
    required this.product,
    required this.detail,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          product.name,
          style: IMatText.h1.copyWith(
            color: IMatColors.black,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (_hasText(detail?.brand))
              _Badge(icon: Icons.storefront_outlined, label: detail!.brand),
            if (_hasText(detail?.origin))
              _Badge(icon: Icons.place_outlined, label: detail!.origin),
            if (product.isEcological)
              const _Badge(icon: Icons.eco_outlined, label: 'Ekologisk'),
          ],
        ),
        const SizedBox(height: 24),
        _PurchaseArea(product: product, unit: unit),
        const SizedBox(height: 34),
        _ProductInfoTabs(product: product, detail: detail),
      ],
    );
  }
}



class _PurchaseArea extends StatelessWidget {
  final Product product;
  final String unit;

  const _PurchaseArea({
    required this.product,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${product.price.toStringAsFixed(2)} kr/$unit',
          style: IMatText.h1.copyWith(
            color: IMatColors.green,
            fontSize: 34,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 12),

        AddToCartButton(
          product: product,
          width: 250,
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: IMatColors.greenLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: IMatColors.green.withValues(alpha: 0.36)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 21, color: IMatColors.green),
          const SizedBox(width: 7),
          Text(
            label,
            style: IMatText.bodyXS.copyWith(
              color: IMatColors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductInfoTabs extends StatefulWidget {
  final Product product;
  final ProductDetail? detail;

  const _ProductInfoTabs({required this.product, required this.detail});

  @override
  State<_ProductInfoTabs> createState() => _ProductInfoTabsState();
}

class _ProductInfoTabsState extends State<_ProductInfoTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _InfoTab('Produktinformation', widget.detail?.description),
      _InfoTab('Innehållsförteckning', widget.detail?.contents),
      _InfoTab('Övrigt', _otherInfo),
    ].where((tab) => tab.content.isNotEmpty).toList();

    if (tabs.isEmpty) {
      return _EmptyInfo();
    }

    final selectedIndex = _selectedIndex.clamp(0, tabs.length - 1).toInt();
    final selectedTab = tabs[selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
  height: 52,
  child: Stack(
    children: [
      Row(
        children: [
          for (var index = 0; index < tabs.length; index++)
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Center(
                  child: Text(
                    tabs[index].title,
                    style: IMatText.bodyS.copyWith(
                      fontSize:15,
                      color: index == selectedIndex
                          ? IMatColors.green
                          : IMatColors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      AnimatedAlign(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        alignment: switch (selectedIndex) {
          0 => Alignment.bottomLeft,
          1 => Alignment.bottomCenter,
          _ => Alignment.bottomRight,
        },
        child: FractionallySizedBox(
          widthFactor: 1 / tabs.length,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: IMatColors.green,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    ],
  ),
),
        const Divider(height: 1, color: IMatColors.border),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 180),
          child: Text(
            selectedTab.content,
            style: IMatText.bodyS.copyWith(
              color: IMatColors.black,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  String get _otherInfo {
    final rows = <String>[];

    if (_hasText(widget.detail?.brand)) {
      rows.add('Varumärke: ${widget.detail!.brand}');
    }
    if (_hasText(widget.detail?.origin)) {
      rows.add('Ursprung: ${widget.detail!.origin}');
    }
    rows.add(widget.product.isEcological ? 'Ekologisk: Ja' : 'Ekologisk: Nej');

    return rows.join('\n');
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 14, 28, 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? IMatColors.green : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: IMatText.bodyS.copyWith(
            color: selected ? IMatColors.green : IMatColors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _EmptyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        style: IMatText.bodyS.copyWith(color: IMatColors.textSecondary),
      ),
    );
  }
}

class _InfoTab {
  final String title;
  final String content;

  _InfoTab(this.title, String? content) : content = content?.trim() ?? '';
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

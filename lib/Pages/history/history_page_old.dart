import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat/shopping_item.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final products = iMat.products;

    if (products.isEmpty) {
      return const Scaffold(
        appBar: IMatNavbar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final orders = _mockOrders(products);

    return Scaffold(
      appBar: const IMatNavbar(activePage: NavbarPage.history),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Orderhistorik', style: IMatText.headingL),
                  const SizedBox(height: 6),
                  Text(
                    'Dina senaste beställningar',
                    style: IMatText.bodyM.copyWith(
                      color: IMatColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            sliver: SliverGrid.builder(
              itemCount: orders.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 360,
                mainAxisExtent: 310,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
              ),
              itemBuilder: (context, index) {
                return _OrderCard(order: orders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsPage extends StatelessWidget {
  final _MockOrder order;

  const _OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IMatNavbar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.formattedDate, style: IMatText.headingL),
                    const SizedBox(height: 6),
                    Text(
                      '${order.formattedTotal} kr',
                      style: IMatText.bodyL.copyWith(
                        color: IMatColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            decoration: BoxDecoration(
              color: IMatColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: IMatColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int index = 0; index < order.items.length; index++)
                  _OrderDetailItem(
                    item: order.items[index],
                    showDivider: index != order.items.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _MockOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IMatColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IMatColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  order.formattedDate,
                  style: IMatText.headingM,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Stack(
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: order.previewItems.length,
                  separatorBuilder: (_, separatorIndex) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _PreviewItem(item: order.previewItems[index]);
                  },
                ),
                if (order.hasMoreItems)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              IMatColors.white.withValues(alpha: 0),
                              IMatColors.white.withValues(alpha: 0.92),
                            ],
                            stops: const [0.45, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Material(
                      color: IMatColors.green.withValues(alpha: 0.94),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Visa order',
                        color: IMatColors.white,
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _OrderDetailsPage(order: order),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Totalt',
                style: IMatText.bodyS.copyWith(color: IMatColors.textSecondary),
              ),
              Text(
                '${order.formattedTotal} kr',
                style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewItem extends StatelessWidget {
  final ShoppingItem item;

  const _PreviewItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: IMatColors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item.product.name,
            style: IMatText.bodyS,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatAmount(item),
          style: IMatText.bodyXS.copyWith(
            color: IMatColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _OrderDetailItem extends StatelessWidget {
  final ShoppingItem item;
  final bool showDivider;

  const _OrderDetailItem({required this.item, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: iMat.getImage(item.product),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: IMatText.bodyL.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAmount(item),
                      style: IMatText.bodyS.copyWith(
                        color: IMatColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${item.total.toStringAsFixed(2)} kr',
                style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: IMatColors.border,
          ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _DeliveryStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDelivered = status == _DeliveryStatus.delivered;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDelivered ? IMatColors.greenLight : IMatColors.chipBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDelivered ? IMatColors.green : IMatColors.border,
        ),
      ),
      child: Text(
        isDelivered ? 'Levererad' : 'På väg',
        style: IMatText.bodyXS.copyWith(
          color: isDelivered ? IMatColors.green : IMatColors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MockOrder {
  final DateTime date;
  final List<ShoppingItem> items;
  final _DeliveryStatus status;

  const _MockOrder({
    required this.date,
    required this.items,
    required this.status,
  });

  List<ShoppingItem> get previewItems => items.take(5).toList();

  bool get hasMoreItems => items.length > previewItems.length;

  String get formattedDate {
    const months = [
      'januari',
      'februari',
      'mars',
      'april',
      'maj',
      'juni',
      'juli',
      'augusti',
      'september',
      'oktober',
      'november',
      'december',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  double get total {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  String get formattedTotal => total.toStringAsFixed(2);
}

enum _DeliveryStatus { inTransit, delivered }

List<_MockOrder> _mockOrders(List<Product> products) {
  final dates = [
    DateTime(2026, 5, 17),
    DateTime(2026, 5, 11),
    DateTime(2026, 5, 2),
    DateTime(2026, 4, 22),
    DateTime(2026, 4, 9),
    DateTime(2026, 3, 28),
    DateTime(2026, 3, 12),
    DateTime(2026, 2, 25),
  ];

  final statuses = [
    _DeliveryStatus.inTransit,
    _DeliveryStatus.delivered,
    _DeliveryStatus.delivered,
    _DeliveryStatus.inTransit,
    _DeliveryStatus.delivered,
    _DeliveryStatus.delivered,
    _DeliveryStatus.inTransit,
    _DeliveryStatus.delivered,
  ];

  final productSets = [
    [0, 4, 8, 13, 18, 23, 29],
    [2, 6, 11, 16, 21],
    [1, 9, 15, 22, 31, 37, 42, 48],
    [3, 10, 17, 24, 30, 36],
    [5, 12, 19, 26, 33, 40, 47],
    [7, 14, 20, 27],
    [25, 28, 34, 39, 44, 50, 55, 60],
    [32, 35, 41, 46, 52],
  ];

  return List.generate(productSets.length, (orderIndex) {
    final items = productSets[orderIndex].asMap().entries.map((entry) {
      final product = products[entry.value % products.length];
      final amount = ((entry.key + orderIndex) % 3) + 1.0;
      return ShoppingItem(product, amount: amount);
    }).toList();

    return _MockOrder(
      date: dates[orderIndex],
      items: items,
      status: statuses[orderIndex],
    );
  });
}

String _formatAmount(ShoppingItem item) {
  final amount = item.amount;
  final formattedAmount = amount % 1 == 0
      ? amount.toInt().toString()
      : amount.toStringAsFixed(1);
  final unit = item.product.unit.replaceAll('kr/', '');

  return '$formattedAmount $unit';
}

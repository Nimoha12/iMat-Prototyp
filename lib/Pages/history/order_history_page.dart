import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/CloseProfile_Button.dart';
import 'package:imat_repo/Widgets/navbar/navbar.dart';
import 'package:imat_repo/model/imat/order.dart';
import 'package:imat_repo/model/imat/shopping_item.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 0;
  final Set<int> _reorderedOrders = {};

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final orders = [...iMat.orders]..sort((a, b) => b.date.compareTo(a.date));

    if (_selectedIndex >= orders.length) {
      _selectedIndex = 0;
    }

    final selectedOrder = orders.isEmpty ? null : orders[_selectedIndex];

    return Scaffold(
      appBar: const IMatNavbar(activePage: NavbarPage.history),
      backgroundColor: IMatColors.beige,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CloseProfileButton(),
                const SizedBox(width: 20),
                Text('Historik', style: IMatText.h2),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: orders.isEmpty
                ? const _EmptyHistory()
                : LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 780;

                if (isNarrow) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 190,
                        child: _OrderList(
                          orders: orders,
                          selectedIndex: _selectedIndex,
                          horizontal: true,
                          onSelect: _selectOrder,
                        ),
                      ),
                      Expanded(
                        child: _OrderDetails(
                          order: selectedOrder!,
                          isReordered: _reorderedOrders.contains(
                            selectedOrder.orderNumber,
                          ),
                          onToggleReorder: () => _toggleReorder(selectedOrder),
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    SizedBox(
                      width: 330,
                      child: _OrderList(
                        orders: orders,
                        selectedIndex: _selectedIndex,
                        onSelect: _selectOrder,
                      ),
                    ),
                    const VerticalDivider(width: 1, color: IMatColors.border),
                    Expanded(
                      child: _OrderDetails(
                        order: selectedOrder!,
                        isReordered: _reorderedOrders.contains(
                          selectedOrder.orderNumber,
                        ),
                        onToggleReorder: () => _toggleReorder(selectedOrder),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ]
          )
    );
  }

  void _selectOrder(int index) {
    setState(() => _selectedIndex = index);
  }

  void _toggleReorder(Order order) {
    final iMat = context.read<ImatDataHandler>();
    final isReordered = _reorderedOrders.contains(order.orderNumber);

    for (final item in order.items) {
      iMat.shoppingCartUpdate(
        ShoppingItem(item.product, amount: item.amount),
        delta: isReordered ? -item.amount : item.amount,
      );
    }

    setState(() {
      if (isReordered) {
        _reorderedOrders.remove(order.orderNumber);
      } else {
        _reorderedOrders.add(order.orderNumber);
      }
    });
  }
}

class _OrderList extends StatelessWidget {
  final List<Order> orders;
  final int selectedIndex;
  final bool horizontal;
  final ValueChanged<int> onSelect;

  const _OrderList({
    required this.orders,
    required this.selectedIndex,
    required this.onSelect,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: IMatColors.white,
      child: ListView.separated(
        scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
        padding: const EdgeInsets.all(18),
        itemCount: orders.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: horizontal ? 12 : 0, height: horizontal ? 0 : 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: horizontal ? 260 : double.infinity,
            child: _OrderCard(
              order: orders[index],
              selected: selectedIndex == index,
              onTap: () => onSelect(index),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final bool selected;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? IMatColors.greenLight : IMatColors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? IMatColors.green : IMatColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDate(order.date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: IMatText.headingM.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                '${order.items.length} ${order.items.length == 1 ? 'vara' : 'varor'}',
                style: IMatText.bodyS.copyWith(color: IMatColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Text(
                '${order.getTotal().toStringAsFixed(2)} kr',
                style: IMatText.bodyL.copyWith(
                  color: IMatColors.green,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  final Order order;
  final bool isReordered;
  final VoidCallback onToggleReorder;

  const _OrderDetails({
    required this.order,
    required this.isReordered,
    required this.onToggleReorder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 34),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order #${order.orderNumber}', style: IMatText.headingL),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(order.date),
                    style: IMatText.bodyM.copyWith(
                      color: IMatColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            _ReorderButton(
              isReordered: isReordered,
              onPressed: onToggleReorder,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _TotalPanel(order: order),
        const SizedBox(height: 18),
        Text('Varor', style: IMatText.headingM),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            color: IMatColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: IMatColors.border),
          ),
          child: Column(
            children: [
              for (int index = 0; index < order.items.length; index++)
                _OrderItemRow(
                  item: order.items[index],
                  showDivider: index < order.items.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReorderButton extends StatelessWidget {
  final bool isReordered;
  final VoidCallback onPressed;

  const _ReorderButton({required this.isReordered, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(isReordered ? Icons.undo : Icons.shopping_cart_checkout),
        label: Text(isReordered ? 'Ångra' : 'Beställ igen'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isReordered ? IMatColors.black : IMatColors.green,
          foregroundColor: IMatColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: IMatText.bodyS.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _TotalPanel extends StatelessWidget {
  final Order order;

  const _TotalPanel({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: IMatColors.greenLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: IMatColors.green),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Totalt',
              style: IMatText.bodyL.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '${order.getTotal().toStringAsFixed(2)} kr',
            style: IMatText.h2.copyWith(
              color: IMatColors.green,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final ShoppingItem item;
  final bool showDivider;

  const _OrderItemRow({required this.item, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 66,
                  height: 66,
                  child: iMat.getImage(item.product),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: IMatText.bodyM.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${_formatAmount(item)} x ${item.product.price.toStringAsFixed(2)} ${_priceUnit(item)}',
                      style: IMatText.bodyS.copyWith(
                        color: IMatColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '${item.total.toStringAsFixed(2)} kr',
                style: IMatText.bodyM.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 14,
            endIndent: 14,
            color: IMatColors.border,
          ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: IMatColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: IMatColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long, size: 48, color: IMatColors.green),
            const SizedBox(height: 14),
            Text('Ingen orderhistorik än', style: IMatText.headingM),
            const SizedBox(height: 8),
            Text(
              'När du slutför ett köp visas det här.',
              textAlign: TextAlign.center,
              style: IMatText.bodyS.copyWith(color: IMatColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
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

String _formatAmount(ShoppingItem item) {
  final amount = item.amount;
  final formattedAmount = amount == amount.roundToDouble()
      ? amount.toInt().toString()
      : amount.toStringAsFixed(1);
  final unit = item.product.unit.replaceAll('kr/', '');

  return '$formattedAmount $unit';
}

String _priceUnit(ShoppingItem item) {
  final unit = item.product.unit;
  return unit.startsWith('kr/') ? unit : 'kr/$unit';
}

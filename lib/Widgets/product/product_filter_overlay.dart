import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Category/ui_categories.dart';
import 'package:imat_repo/Widgets/product/filter_selection.dart';
import 'package:imat_repo/Widgets/product/product_filter_panel.dart';

/// Full-screen filter sheet over the navbar, matching [Cart].
class ProductFilterOverlay extends StatefulWidget {
  final double initialMaxPrice;
  final EcoFilter initialEcoFilter;
  final String initialSortBy;
  final FilterSelection initialSelection;
  final UiCategory? contextCategory;
  final bool showCategoryFilter;
  final void Function({
    required double maxPrice,
    required EcoFilter ecoFilter,
    required String sortBy,
    required FilterSelection selection,
  }) onChanged;

  const ProductFilterOverlay({
    super.key,
    required this.initialMaxPrice,
    required this.initialEcoFilter,
    required this.initialSortBy,
    required this.initialSelection,
    required this.onChanged,
    this.contextCategory,
    this.showCategoryFilter = true,
  });

  static Future<void> show(
    BuildContext context, {
    required double maxPrice,
    required EcoFilter ecoFilter,
    required String sortBy,
    required FilterSelection selection,
    required void Function({
      required double maxPrice,
      required EcoFilter ecoFilter,
      required String sortBy,
      required FilterSelection selection,
    }) onChanged,
    UiCategory? contextCategory,
    bool showCategoryFilter = true,
  }) {
    return Navigator.push<void>(
      context,
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductFilterOverlay(
          initialMaxPrice: maxPrice,
          initialEcoFilter: ecoFilter,
          initialSortBy: sortBy,
          initialSelection: selection,
          onChanged: onChanged,
          contextCategory: contextCategory,
          showCategoryFilter: showCategoryFilter,
        ),
      ),
    );
  }

  @override
  State<ProductFilterOverlay> createState() => _ProductFilterOverlayState();
}

class _ProductFilterOverlayState extends State<ProductFilterOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  late double maxPrice;
  late EcoFilter ecoFilter;
  late String sortBy;
  late FilterSelection selection;

  @override
  void initState() {
    super.initState();

    maxPrice = widget.initialMaxPrice;
    ecoFilter = widget.initialEcoFilter;
    sortBy = widget.initialSortBy;
    selection = widget.initialSelection;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  void _notifyParent() {
    widget.onChanged(
      maxPrice: maxPrice,
      ecoFilter: ecoFilter,
      sortBy: sortBy,
      selection: selection,
    );
  }

  void _clearFilters() {
    setState(() {
      maxPrice = ProductFilterDefaults.maxPrice;
      ecoFilter = ProductFilterDefaults.ecoFilter;
      sortBy = ProductFilterDefaults.sortBy;
      selection = ProductFilterDefaults.selection;
    });
    _notifyParent();
  }

  Future<void> _closeFilter() async {
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
    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _closeFilter,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SlideTransition(
              position: _slideAnimation,
              child: ProductFilterPanel(
                maxPrice: maxPrice,
                onPriceChange: (v) {
                  setState(() => maxPrice = v);
                  _notifyParent();
                },
                ecoFilter: ecoFilter,
                onEcoChange: (v) {
                  setState(() => ecoFilter = v);
                  _notifyParent();
                },
                sortBy: sortBy,
                onSortChange: (v) {
                  setState(() => sortBy = v);
                  _notifyParent();
                },
                selection: selection,
                onSelectionChanged: (s) {
                  setState(() => selection = s);
                  _notifyParent();
                },
                contextCategory: widget.contextCategory,
                showCategoryFilter: widget.showCategoryFilter,
                onClose: _closeFilter,
                onApplyFilters: _closeFilter,
                onClearFilters: _clearFilters,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

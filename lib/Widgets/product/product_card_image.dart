import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:imat_repo/model/imat/product.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

/// Loads the product image only when the card is near the viewport.
class ProductCardImage extends StatefulWidget {
  final Product product;

  const ProductCardImage({super.key, required this.product});

  @override
  State<ProductCardImage> createState() => _ProductCardImageState();
}

class _ProductCardImageState extends State<ProductCardImage> {
  static const _prefetchExtent = 300.0;

  final GlobalKey _visibilityKey = GlobalKey();

  bool _load = false;
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  void _attachScrollPosition() {
    final position = Scrollable.maybeOf(context)?.position;
    if (position == _scrollPosition) return;

    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = position;
    _scrollPosition?.addListener(_onScroll);
  }

  void _onScroll() => _updateVisibility();

  void _updateVisibility() {
    if (!mounted || _load) return;

    final box = _visibilityKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final position = _scrollPosition;
    if (position == null) {
      setState(() => _load = true);
      return;
    }

    final viewport = RenderAbstractViewport.maybeOf(box);
    if (viewport == null) {
      setState(() => _load = true);
      return;
    }

    final reveal = viewport.getOffsetToReveal(box, 0.0);
    final itemTop = reveal.offset;
    final itemBottom = itemTop + box.size.height;
    final viewportStart = position.pixels - _prefetchExtent;
    final viewportEnd =
        position.pixels + position.viewportDimension + _prefetchExtent;

    if (itemBottom >= viewportStart && itemTop <= viewportEnd) {
      setState(() => _load = true);
      _scrollPosition?.removeListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (!_load) {
      image = Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.cover,
      );
    } else {
      final iMat = context.watch<ImatDataHandler>();
      image = iMat.getImage(widget.product);
    }

    return SizedBox.expand(
      key: _visibilityKey,
      child: image,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController controller;
  final double threshold;

  const ScrollToTopButton({
    super.key,
    required this.controller,
    this.threshold = 250,
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final shouldShow = widget.controller.offset > widget.threshold;
      if (shouldShow != _visible) {
        setState(() => _visible = shouldShow);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return Positioned(
      right: 32,
      bottom: 32,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: FloatingActionButton.large(
          elevation: 10,
          backgroundColor: IMatColors.green, 
          shape: const CircleBorder(), 
          onPressed: () {
            widget.controller.animateTo(
              0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          },
          child: const Icon(
            Icons.arrow_upward,
            color: IMatColors.white,
            size: 50,
            weight: 1000,
          ),
        ),
      ),
    );
  }
}

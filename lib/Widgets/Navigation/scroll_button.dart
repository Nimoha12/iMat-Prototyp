import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

class ScrollToTopButton extends StatelessWidget {
  final ScrollController controller;

  const ScrollToTopButton({
    super.key,
    required this.controller,
  });

  void _scrollToTop() {
    controller.jumpTo(0); // direkt teleportering
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      right: 32,
      child: FloatingActionButton(
        backgroundColor: IMatColors.green,
        onPressed: _scrollToTop,
        child: const Icon(Icons.arrow_upward, color: Colors.white, size: 28),
      ),
    );
  }
}

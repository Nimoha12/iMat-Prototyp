import 'package:flutter/material.dart';

class HoverCloseIcon extends StatefulWidget {
  final VoidCallback onClose;

  const HoverCloseIcon({super.key, required this.onClose});

  @override
  State<HoverCloseIcon> createState() => _HoverCloseIconState();
}

class _HoverCloseIconState extends State<HoverCloseIcon> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        scale: hovering ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onClose,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.close,
              size: 26,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
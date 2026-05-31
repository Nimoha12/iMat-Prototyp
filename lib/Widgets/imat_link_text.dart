import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

/// Green underlined text link with pointer cursor and lighter hover color.
class IMatLinkText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle style;
  final EdgeInsetsGeometry? padding;

  const IMatLinkText({
    super.key,
    required this.text,
    required this.onTap,
    required this.style,
    this.padding,
  });

  @override
  State<IMatLinkText> createState() => _IMatLinkTextState();
}

class _IMatLinkTextState extends State<IMatLinkText> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      widget.text,
      style: widget.style.copyWith(
        color: _hovered ? IMatColors.greenHover : IMatColors.green,
        decoration: TextDecoration.underline,
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.padding != null
            ? Padding(padding: widget.padding!, child: text)
            : text,
      ),
    );
  }
}

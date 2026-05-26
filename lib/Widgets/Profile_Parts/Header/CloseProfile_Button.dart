

import 'package:flutter/material.dart';

class CloseProfileButton
    extends StatelessWidget {

  const CloseProfileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -2),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        alignment: Alignment.center,
        icon: const SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Icon(
              Icons.close,
              size: 38,
            ),
          ),
        ),
      ),
    );
  }
}
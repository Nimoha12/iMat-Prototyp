import 'package:flutter/material.dart';

class CloseProfileButton
    extends StatelessWidget {

  const CloseProfileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
      icon: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black54,
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.close,
          size: 20,
        ),
      ),
    );
  }
}
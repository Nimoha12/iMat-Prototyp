import 'package:flutter/material.dart';

class IMatLogo extends StatelessWidget {
  final VoidCallback? onTap;

  const IMatLogo({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: const [
          Text(
            "i",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Mat",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}

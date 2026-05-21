import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {

  final IconData icon;
  final String text;
  final bool selected;

  const ProfileTab({
    super.key,
    required this.icon,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),

      decoration: selected
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF3F8A73),
                  width: 4,
                ),
              ),
            )
          : null,

      child: Column(
        children: [

          Icon(
            icon,
            size: 34,

            color: selected
                ? const Color(0xFF3F8A73)
                : Colors.grey,
          ),

          const SizedBox(height: 10),

          Text(
            text,

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,

              color: selected
                  ? const Color(0xFF3F8A73)
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
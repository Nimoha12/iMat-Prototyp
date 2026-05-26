import 'package:flutter/material.dart';

class CreditCardField extends StatelessWidget {
  final String title;
  final bool isEditing;
  final TextEditingController controller;

  const CreditCardField({
    super.key,
    required this.controller,
    required this.title,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: isEditing,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
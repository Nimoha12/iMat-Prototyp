import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';

class EditableCustomerField extends StatelessWidget {
  final String title;
  final bool isEditing;
  final TextEditingController controller;

  const EditableCustomerField({
    super.key,
    required this.controller,
    required this.isEditing,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF222222),
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: controller,
          enabled: isEditing,
          textInputAction: TextInputAction.done,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: IMatColors.textSecondary,
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),

              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),

              borderSide: const BorderSide(
                color: Color(0xFF3F8A73),
                width: 3,
              ),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),

              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
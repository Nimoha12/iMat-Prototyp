import 'package:flutter/material.dart';

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
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: controller,
          enabled: isEditing,

          style: const TextStyle(
            fontSize: 18,
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              borderSide:
                  BorderSide(
                color: isEditing
                    ? Colors.grey.shade300
                    : Colors.transparent,
              ),
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              borderSide:
                  const BorderSide(
                color:
                    Color(0xFF3F8A73),
                width: 3,
              ),
            ),

            disabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              borderSide:
                  const BorderSide(
                color:
                    Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
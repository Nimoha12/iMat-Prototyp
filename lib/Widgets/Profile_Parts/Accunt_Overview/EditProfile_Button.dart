import 'package:flutter/material.dart';

class EditProfileButton
    extends StatelessWidget {

  final VoidCallback onPressed;

  const EditProfileButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 190,
      height: 70,

      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF3F8A73),

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),

        onPressed: onPressed,

        icon: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 24,
        ),

        label: const Text(
          "Redigera",

          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ProfileContentHeader
    extends StatelessWidget {

  final Widget editButton;

  const ProfileContentHeader({
    super.key,
    required this.editButton,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        const Text(
          "Kontoinformation",

          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        editButton,
      ],
    );
  }
}
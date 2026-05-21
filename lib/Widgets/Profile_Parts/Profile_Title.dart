import 'package:flutter/material.dart';

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {

    return const Text(
      "Min profil",

      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
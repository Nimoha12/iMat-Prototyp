import 'package:flutter/material.dart';

class IMatColors {
  // Ljusare och mer färgglad version av originalgrön (#2F6E5D → #3A7D6B)
  // Ger bättre kontrast mot vit text utan att bli limegrön
  static const green = Color(0xFF3A7D6B);

  // Lättare bakgrundsgrön för hover och sekundära ytor (#E4F0EC → #E8F3EF)
  static const greenLight = Color(0xFFE8F3EF);
  // Gråare grön för markerad navbar-ikon
  static const navSelectedBackground = Color.fromRGBO(255, 255, 255, 0.80);

  // Hover-färg något ljusare för bättre synlighet (#3F8571 → #4A947E)
  static const greenHover = Color(0xFF4A947E);

  // Beige justerad marginellt för varmare ton (#F7F4EE → #F5F0E8)
  static const beige = Color(0xFFF5F0E8);

  static const white = Colors.white;
  static const black = Colors.black;

  // Lättare grå för bättre kontrast mot beige (#D9D9D9 → #D0D0D0)
  static const border = Color(0xFFD0D0D0);

  // Sekundär textfärg något mörkare för bättre läsbarhet (#5F5F5F → #4A4A4A)
  static const textSecondary = Color(0xFF4A4A4A);

  static const chipBackground = Color(0xFFF1F1F1);
  static const selectedChip = Color(0xFF3A7D6B); // matchar huvudgrön
}

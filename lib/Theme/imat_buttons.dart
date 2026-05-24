import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'imat_colors.dart';

class IMatButton {
  // Förbättrad kontrast och större text
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: IMatColors.white,
    foregroundColor: IMatColors.black,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
    textStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static ButtonStyle small = ElevatedButton.styleFrom(
    backgroundColor: IMatColors.green,
    foregroundColor: IMatColors.white,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    textStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

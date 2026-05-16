import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'imat_colors.dart';

class IMatButton {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: IMatColors.white,
    foregroundColor: IMatColors.black,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    textStyle: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle small = ElevatedButton.styleFrom(
  backgroundColor: IMatColors.green,
  foregroundColor: IMatColors.white,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  textStyle: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
  ),
);

}

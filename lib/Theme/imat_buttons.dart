import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'imat_colors.dart';
import 'imat_text.dart';

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

  static ButtonStyle outlinedGreen = OutlinedButton.styleFrom(
    foregroundColor: IMatColors.green,
    side: const BorderSide(color: IMatColors.green, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w700),
  );

  static ButtonStyle outlinedRed = OutlinedButton.styleFrom(
    foregroundColor: IMatColors.danger,
    side: const BorderSide(color: IMatColors.danger, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w700),
  );

  static ButtonStyle primaryGreen = ElevatedButton.styleFrom(
    backgroundColor: IMatColors.green,
    disabledBackgroundColor: IMatColors.border,
    foregroundColor: IMatColors.white,
    disabledForegroundColor: IMatColors.textSecondary,
    elevation: 0,
    textStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w800),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

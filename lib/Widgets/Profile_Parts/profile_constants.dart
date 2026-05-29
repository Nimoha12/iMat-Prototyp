import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';

const Color profilePageBackground = IMatColors.beige;
const Color profileSurfaceColor = IMatColors.white;
const Color profilePrimaryColor = IMatColors.green;
const Color profilePrimaryLightColor = IMatColors.greenLight;
const Color profileBorderColor = IMatColors.border;
const Color profileTextColor = IMatColors.black;
const Color profileMutedTextColor = IMatColors.textSecondary;

const double profileMaxWidth = 1120;
const double profileFieldWidth = 285;
const double profileFieldHeight = 58;
const double profileTouchTarget = 56;
const double profileCardRadius = 8;
const double profileSectionGap = 22;

const TextStyle profilePageTitleStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.w800,
  color: profileTextColor,
);

const TextStyle profileModuleTitleStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w800,
  color: profileTextColor,
);

const TextStyle profileSectionTitleStyle = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.w800,
  color: profileTextColor,
);

const TextStyle profileHelperTextStyle = TextStyle(
  fontSize: 17,
  height: 1.35,
  fontWeight: FontWeight.w500,
  color: profileMutedTextColor,
);

const TextStyle profileFieldLabelStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w800,
  color: profileTextColor,
);

const TextStyle profileFieldTextStyle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.w600,
  color: profileMutedTextColor,
);

ButtonStyle profileIconButtonStyle() {
  return IconButton.styleFrom(
    foregroundColor: profileTextColor,
    minimumSize: const Size(profileTouchTarget, profileTouchTarget),
    tapTargetSize: MaterialTapTargetSize.padded,
  );
}

ButtonStyle profileTabButtonStyle({required bool selected}) {
  return TextButton.styleFrom(
    backgroundColor: selected ? profilePrimaryColor : profilePrimaryLightColor,
    foregroundColor: selected ? profileSurfaceColor : profileTextColor,
    minimumSize: const Size(0, profileTouchTarget),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(profileCardRadius),
      side: BorderSide(
        color: selected ? profilePrimaryColor : profileBorderColor,
        width: selected ? 2 : 1.5,
      ),
    ),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
  );
}

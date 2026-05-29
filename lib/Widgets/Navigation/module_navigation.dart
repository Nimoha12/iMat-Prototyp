import 'package:flutter/material.dart';

class ModuleNavigation {
  static bool insideModuleArea = false;

  static void enter() {
    insideModuleArea = true;
  }

  static void exit(BuildContext context) {
    insideModuleArea = false;

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
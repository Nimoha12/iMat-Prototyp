import 'package:flutter/foundation.dart';

void dbugPrint(message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

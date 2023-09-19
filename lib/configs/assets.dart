import 'dart:io';

import 'package:flutter/foundation.dart';

final class Assets {
  static const arrowUpDown = 'assets/arrow-up-down.svg';
}

final class AdHelper {
  static String get nativeAdUnitId {
    // Release AD
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3368479970508752/2376612907';
      } else if (Platform.isIOS) {
        return 'IOS';
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    }

    // Test AD
    else {
      return 'ca-app-pub-3940256099942544/2247696110';
    }
  }
}

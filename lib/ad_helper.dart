import 'dart:io';

import 'package:drinkscounter/Settings.dart';

class AdHelper {
  
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return Settings.release ? 'ca-app-pub-2032072582529697/8735325207' : 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return Settings.release ? 'ca-app-pub-2032072582529697/3970055437' : 'ca-app-pub-3940256099942544/2934735716';
    }
    throw new UnsupportedError("Unsupported platform");
  }
  
//  static String get nativeAdUnitId {
//    if (Platform.isAndroid) {
//      return 'ca-app-pub-3940256099942544/2247696110';
//    } else if (Platform.isIOS) {
//      return 'ca-app-pub-3940256099942544/3986624511';
//    }
//    throw new UnsupportedError("Unsupported platform");
//  }
}
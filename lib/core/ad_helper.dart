import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1777395567852331/6140998796';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitListTips {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1777395567852331/8170338366';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1777395567852331/8170338366';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitIdDetailsTips {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1777395567852331/3494685979';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1777395567852331/3494685979';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

}

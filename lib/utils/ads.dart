// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdIds {
  // ad's id
  static const String SPLASH_INTERSTITIAL_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-5244304915957936/7364652643';

  static const String ONGENERATE_INTERSTITIAL_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/2723786510';

  static const String ONGENERATE_REWARD_AD_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/6645740990';

  static const String APP_OPEN_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-5244304915957936/7364652643';

  static const String BANNER_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-5244304915957936/7829361543';

  static const String NATIVE_AD_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'cca-app-pub-5244304915957936/7314356224';

  ///Customize your adRequest here
  static AdRequest get adRequest => const AdRequest(httpTimeoutMillis: 6000);
}

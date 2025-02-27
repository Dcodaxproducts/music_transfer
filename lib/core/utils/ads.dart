// ignore_for_file: constant_identifier_names

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdIds {
  // ad's id
  static const String INTERSTITIAL_ID =
      'ca-app-pub-3940256099942544/1033173712';

  static const String REWARD_VIDEO_AD_ID =
      'ca-app-pub-3940256099942544/5224354917';

  static const String REWARD_INTERSTITIAL_AD_ID =
      'ca-app-pub-3940256099942544/5354046379';

  static const String APP_OPEN_ID = 'ca-app-pub-3940256099942544/9257395921';

  static const String BANNER_ID = 'ca-app-pub-3940256099942544/6300978111';

  static const String NATIVE_AD_ID = 'ca-app-pub-3940256099942544/2247696110';

  static AdRequest get adRequest => const AdRequest(httpTimeoutMillis: 6000);
}

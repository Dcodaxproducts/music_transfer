import '../../../../imports.dart';

class AdIds {
  // ad's id
  static const String interstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardVideo = 'ca-app-pub-3940256099942544/5224354917';
  static const String rewardInterstitial = 'ca-app-pub-3940256099942544/5354046379';
  static const String appOpen = 'ca-app-pub-3940256099942544/9257395921';
  static const String banner = 'ca-app-pub-3940256099942544/6300978111';
  static const String native = 'ca-app-pub-3940256099942544/2247696110';
  static AdRequest get adRequest => const AdRequest(httpTimeoutMillis: 8000);
}

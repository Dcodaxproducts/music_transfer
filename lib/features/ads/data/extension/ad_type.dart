import '../enum/ad_type.dart';

extension AdTypeExtension on AdType {
  static AdType? fromString(String? value) {
    switch (value) {
      case 'reward':
        return AdType.reward;
      case 'rewarded_interstitial':
        return AdType.rewardedInterstitial;
      case 'interstitial':
        return AdType.interstitial;
      case 'banner':
        return AdType.banner;
      case 'app_open':
        return AdType.appOpen;
      case 'native':
        return AdType.nativeMedium;
      case 'native_medium':
        return AdType.nativeMedium;
      case 'native_small':
        return AdType.nativeSmall;
      default:
        return null;
    }
  }
}

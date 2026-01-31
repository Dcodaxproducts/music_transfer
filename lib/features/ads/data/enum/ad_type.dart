import '../utils/ads.dart';

enum AdType {
  reward('reward', AdIds.rewardVideo),
  interstitial('interstitial', AdIds.interstitial),
  banner('banner', AdIds.banner),
  appOpen('app_open', AdIds.appOpen),
  nativeMedium('native_medium', AdIds.native),
  nativeSmall('native_small', AdIds.native),
  rewardedInterstitial('rewarded_interstitial', AdIds.rewardInterstitial);

  final String name;
  final String testId;
  const AdType(this.name, this.testId);

  static AdType fromString(String? value) {
    return AdType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AdType.interstitial,
    );
  }
}

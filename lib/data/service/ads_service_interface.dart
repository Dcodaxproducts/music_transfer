abstract class AdsServiceInterface {
  /// Set the status of ads (enable or disable) based on conditions.
  void setAdStatus();

  /// Initialize the ads and request consent if needed.
  void initialize();

  /// Load and display the consent form for ads.
  void loadForm();

  /// Show an interstitial ad.
  Future<void> showOnGenerateInterstitial();

  /// Show a rewarded video ad.
  Future<void> showOnGenerateRewardVideo();

  /// Show an app open ad.
  Future<void> showAppOpen();
}

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/data/model/response/ad_model.dart';
import 'package:easy_audience_network/easy_audience_network.dart' as meta;

abstract class AdsServiceInterface {
  Future<List<AdModel>> getAdIds();

  /// Initialize the ads and request consent if needed.
  void initialize();

  /// Load and display the consent form for ads.
  void loadForm();

  /// Show an interstitial ad.
  Future<void> showInterstitial(String adId);

  /// Show a rewarded video ad.
  Future<void> showRewardVideo(String adId);

  // Show a rewarded interstitial ad.
  Future<void> showRewardInterstitial(String adId);

  /// Show an app open ad.
  Future<AppOpenAd?> showAppOpen(String adId);

  /// Get the banner widget for the given ad.
  Widget getBannerWidget(AdModel? ad);

  Future<RewardedInterstitialAd?> loadRewardInterstitialAd(String adId);

  Future<RewardedAd?> loadRewardVideoAd(String adId);

  Future<InterstitialAd?> loadInterstitial(String adId);

  // Facebook ads
  Future<void> showFacebookInterstitial(String adId);

  Future<void> showFacebookRewardAd(String adId);

  Widget getFacebookBannerWidget(AdModel? ad);

  Future<meta.InterstitialAd?> showAppOpenFacebook(String adId);
}

import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:pixart_app/features/ads/data/utils/ads.dart';
import 'package:pixart_app/imports.dart';
import '../../../paywall/presentation/controller/subscription_controller.dart';
import '../../presentation/controller/ads_controller.dart';
import 'ad_repo.dart';

class AdRepoImpl implements AdRepo {
  final ApiClient apiClient;
  AdRepoImpl({required this.apiClient});

  @override
  Future<Response?> getAdIds() async {
    return await apiClient.get(Endpoints.ads);
  }

  @override
  Future<T?> loadAd<T>(String unitId) async {
    if (SubscriptionController.find.isPro) return null;
    Completer<T?> completer = Completer();

    void loadCallback(ad) {
      if (!completer.isCompleted) {
        completer.complete(ad);
        FirebaseAnalytics.instance.logAdImpression();
      }
    }

    void failCallback(error) {
      log("Failed to load ad: ${error.message}");
      if (!completer.isCompleted) completer.complete();
    }

    switch (T) {
      case const (InterstitialAd):
        _loadInterstitialAd(unitId, loadCallback, failCallback);
        break;
      case const (RewardedInterstitialAd):
        _loadRewardedInterstitialAd(unitId, loadCallback, failCallback);
        break;
      case const (RewardedAd):
        _loadRewardedAd(unitId, loadCallback, failCallback);
        break;
      case const (AppOpenAd):
        _loadAppOpenAd(unitId, loadCallback, failCallback);
        break;
    }

    return await completer.future.timeout(const Duration(seconds: 6), onTimeout: () => null);
  }

  /* Admob Ads */

  Future<void> _loadInterstitialAd(
    String unitId,
    Function(InterstitialAd) loadCallback,
    Function(AdError) failCallback,
  ) async {
    return await InterstitialAd.load(
      adUnitId: unitId,
      request: AdIds.adRequest,
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: loadCallback, onAdFailedToLoad: failCallback),
    );
  }

  Future<void> _loadRewardedAd(
    String unitId,
    Function(RewardedAd) loadCallback,
    Function(AdError) failCallback,
  ) async {
    return await RewardedAd.load(
      adUnitId: unitId,
      request: AdIds.adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: loadCallback,
        onAdFailedToLoad: failCallback,
      ),
    );
  }

  Future<void> _loadRewardedInterstitialAd(
    String unitId,
    Function(RewardedInterstitialAd) loadCallback,
    Function(AdError) failCallback,
  ) async {
    return await RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: AdIds.adRequest,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: loadCallback,
        onAdFailedToLoad: failCallback,
      ),
    );
  }

  Future<void> _loadAppOpenAd(
    String unitId,
    Function(AppOpenAd) loadCallback,
    Function(AdError) failCallback,
  ) async {
    return await AppOpenAd.load(
      adUnitId: unitId,
      request: AdIds.adRequest,
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: loadCallback, onAdFailedToLoad: failCallback),
    );
  }

  @override
  FullScreenContentCallback<T> getFullScreenContentCallback<T>() => FullScreenContentCallback<T>(
    onAdDismissedFullScreenContent: (ad) {
      AdsController.find.adShowing = false;
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      AdsController.find.adShowing = false;
    },
    onAdShowedFullScreenContent: (ad) {
      AdsController.find.adShowing = true;
    },
  );
}

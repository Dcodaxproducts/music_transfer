import 'dart:async';
import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/features/ads/data/utils/ads.dart';
import 'package:pixart_app/imports.dart';
import '../../../paywall/presentation/controller/subscription_controller.dart';
import '../../presentation/controller/ads_controller.dart';
import 'ad_repo_interface.dart';
import 'package:easy_audience_network/easy_audience_network.dart' as meta;

class AdRepo implements AdRepoInterface {
  final ApiClient apiClient;
  AdRepo({required this.apiClient});

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
      case const (meta.InterstitialAd):
        _loadMetaInterstitialAd(unitId, loadCallback, failCallback);
      case const (meta.RewardedAd):
        _loadMetaRewardedAd(unitId, loadCallback, failCallback);
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

  /* Meta ads */

  Future<void> _loadMetaInterstitialAd(
    String unitId,
    Function(meta.InterstitialAd) loadCallback,
    Function(dynamic) failCallback,
  ) async {
    final interstitialAd = meta.InterstitialAd(kDebugMode ? meta.InterstitialAd.testPlacementId : unitId);

    interstitialAd.listener = meta.InterstitialAdListener(
      onLoaded: () => loadCallback(interstitialAd),
      onDismissed: interstitialAd.destroy,
      onError: (code, error) {
        failCallback(error);
        interstitialAd.destroy();
      },
    );

    return await interstitialAd.load();
  }

  Future<void> _loadMetaRewardedAd(
    String unitId,
    Function(meta.RewardedAd) loadCallback,
    Function(dynamic) failCallback,
  ) async {
    final rewardedAd = meta.RewardedAd(kDebugMode ? meta.RewardedAd.testPlacementId : unitId);

    rewardedAd.listener = meta.RewardedAdListener(
      onLoaded: () => loadCallback(rewardedAd),
      onVideoClosed: rewardedAd.destroy,
      onError: (code, error) {
        failCallback(error);
        rewardedAd.destroy();
      },
    );

    return await rewardedAd.load();
  }
}

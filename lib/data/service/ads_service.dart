import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/data/repository/ad_repo_interface.dart';
import '../../controller/subscription_controller.dart';
import '../../utils/ads.dart';
import '../../view/base/common/snackbar.dart';
import '../../view/base/ads/ad_loading_dialog.dart';
import '../../view/base/ads/native_ad.dart';
import '../model/response/ad_model.dart';
import '../model/response/model.dart';
import 'ads_service_interface.dart';

class AdsService implements AdsServiceInterface {
  final AdRepoInterface adRepo;
  AdsService({required this.adRepo});

  @override
  Future<List<AdModel>> getAdIds() async {
    List<AdModel> ads = [];
    final response = await adRepo.getAdIds();
    if (response != null) {
      final data = jsonDecode(response.body)['ads'];
      for (var item in data) {
        ads.add(AdModel.fromJson(item));
      }
    }
    return ads;
  }

  @override
  void initialize() async {
    // Show tracking authorization dialog and ask for permission
    await AppTrackingTransparency.requestTrackingAuthorization();
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(params, () {
      ConsentInformation.instance.isConsentFormAvailable().then((value) {
        loadForm();
      });
    }, (error) {
      // showSnack("Consent initialization failed: ${error.message}");
    });
  }

  @override
  void loadForm() {
    ConsentForm.loadConsentForm((consentForm) async {
      if (await ConsentInformation.instance.getConsentStatus() == ConsentStatus.required) {
        consentForm.show((formError) {
          if (formError != null) {
            // showSnack("Consent form error: ${formError.message}");
          }
        });
      }
    }, (formError) {
      // showSnack("Failed to load consent form: ${formError.message}");
    });
  }

  @override
  Future<void> showInterstitial(String adId) async {
    if (isPro) return;
    showAdLoadingDialog();
    InterstitialAd? interstitialAd = await loadInterstitial(adId);
    if (interstitialAd != null) {
      await interstitialAd.show();
    }
    dismiss();
  }

  @override
  Future<void> showRewardVideo(String adId) async {
    if (isPro) return;
    showAdLoadingDialog();
    RewardedAd? rewardedAd = await loadRewardVideoAd(adId);
    if (rewardedAd != null) {
      await rewardedAd.show(onUserEarnedReward: (ad, reward) {
        FirebaseAnalytics.instance.logAdImpression();
      });
    }
    dismiss();
  }

  @override
  Future<void> showRewardInterstitial(String adId) async {
    if (isPro) return;
    showAdLoadingDialog();
    RewardedInterstitialAd? rewardedAd = await loadRewardInterstitialAd(adId);
    if (rewardedAd != null) {
      await rewardedAd.show(onUserEarnedReward: (ad, reward) {
        FirebaseAnalytics.instance.logAdImpression();
      });
    }
    dismiss();
  }

  @override
  Future<AppOpenAd?> showAppOpen(String adId) async {
    if (isPro) return null;
    return await _loadOpenAd(adId);
  }

  @override
  Future<InterstitialAd?> loadInterstitial(String unitId) async {
    Completer<InterstitialAd?> completer = Completer();

    InterstitialAd.load(
      adUnitId: kDebugMode ? AdIds.INTERSTITIAL_ID : unitId,
      request: AdIds.adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) {
            completer.complete(ad);
            FirebaseAnalytics.instance.logAdImpression();
          }
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      ),
    );

    try {
      return await completer.future.timeout(const Duration(seconds: 4), onTimeout: () {
        if (!completer.isCompleted) completer.complete();
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<AppOpenAd?> _loadOpenAd(String unitId) async {
    Completer<AppOpenAd?> completer = Completer();

    AppOpenAd.load(
      adUnitId: kDebugMode ? AdIds.APP_OPEN_ID : unitId,
      request: AdIds.adRequest,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) {
            completer.complete(ad);
            FirebaseAnalytics.instance.logAdImpression();
          }
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      return await completer.future.timeout(const Duration(seconds: 4), onTimeout: () {
        if (!completer.isCompleted) completer.complete();
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Future<RewardedAd?> loadRewardVideoAd(String unitId) async {
    Completer<RewardedAd?> completer = Completer();
    RewardedAd.load(
      adUnitId: kDebugMode ? AdIds.REWARD_VIDEO_AD_ID : unitId,
      request: AdIds.adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) {
            completer.complete(ad);
            FirebaseAnalytics.instance.logAdImpression();
          }
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      return await completer.future.timeout(const Duration(seconds: 4), onTimeout: () {
        if (!completer.isCompleted) completer.complete();
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Future<RewardedInterstitialAd?> loadRewardInterstitialAd(String unitId) async {
    Completer<RewardedInterstitialAd?> completer = Completer();
    RewardedInterstitialAd.load(
      adUnitId: kDebugMode ? AdIds.REWARD_INTERSTITIAL_AD_ID : unitId,
      request: AdIds.adRequest,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) {
            completer.complete(ad);
            FirebaseAnalytics.instance.logAdImpression();
          }
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      return await completer.future.timeout(const Duration(seconds: 4), onTimeout: () {
        if (!completer.isCompleted) completer.complete();
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Widget getBannerWidget(AdModel? ad) {
    Widget adWidget = const SizedBox.shrink();
    // if ad is not null and active and type is interstitial
    if (ad != null && ad.active) {
      String adId = _getAdId(ad);
      if (ad.type == AdType.banner) {
        adWidget = FutureBuilder(
            future: AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.sizeOf(Get.context!).width.truncate(),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final size = snapshot.data as AdSize;
              return BannerAdWidget(adId: adId, adSize: size);
            });
      } else if (ad.type == AdType.native) {
        {
          adWidget = NativeAdWidget(adId: adId);
        }
      }
    }
    return adWidget;
  }

  _getAdId(AdModel ad) {
    String adId = '';
    adId = Platform.isAndroid ? ad.androidAdId : ad.iosAdId;
    if (kDebugMode) {
      adId = AdIds.BANNER_ID;
    }
    return adId;
  }

  void showSnack(String text) {
    showToast(text, success: false);
  }
}

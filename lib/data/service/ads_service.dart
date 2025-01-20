import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/data/repository/ad_repo_interface.dart';
import 'package:matrix_ai/imports.dart';
import '../../controller/subscription_controller.dart';
import '../../utils/ads.dart';
import '../../view/base/ads/native_ad.dart';
import '../model/response/ad_model.dart';
import '../model/response/model.dart';
import 'ads_service_interface.dart';
import 'package:easy_audience_network/easy_audience_network.dart' as meta;

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
    // showAdLoadingDialog();
    InterstitialAd? interstitialAd = await loadInterstitial(adId);
    if (interstitialAd != null) {
      await interstitialAd.show();
    }
    dismiss();
  }

  @override
  Future<void> showRewardVideo(String adId) async {
    if (isPro) return;
    // showAdLoadingDialog();
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
    // showAdLoadingDialog();
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
    if (Platform.isAndroid) return getFacebookBannerWidget(ad);
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

  // Facebook Ads

  @override
  Future<void> showFacebookInterstitial(String adId) async {
    if (isPro) return; // Skip if user is Pro
    // showAdLoadingDialog();
    meta.InterstitialAd? ad = await loadFacebookInterstitial(adId);
    if (ad != null) {
      await ad.show(); // Show the ad if loaded
      ad.destroy(); // Clean up resources after showing
    }
    dismiss(); // Ensure the dialog is dismissed in all cases
  }

  Future<meta.InterstitialAd?> loadFacebookInterstitial(String adId) async {
    if (isPro) return null; // Skip loading if user is Pro

    Completer<meta.InterstitialAd?> completer = Completer();

    // Create a new interstitial ad instance
    final interstitialAd = meta.InterstitialAd(kDebugMode ? meta.InterstitialAd.testPlacementId : adId);

    // Attach event listeners
    interstitialAd.listener = meta.InterstitialAdListener(
      onLoaded: () {
        if (!completer.isCompleted) {
          completer.complete(interstitialAd); // Complete with the loaded ad
          FirebaseAnalytics.instance.logAdImpression();
        }
      },
      onError: (code, error) {
        if (!completer.isCompleted) {
          completer.complete(null); // Complete with null on error
        }
        interstitialAd.destroy(); // Destroy the ad to release resources
      },
      onDismissed: () {
        interstitialAd.destroy(); // Ensure the ad is destroyed after dismissal
      },
    );

    // Attempt to load the ad
    interstitialAd.load();

    try {
      return await completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete(null); // Timeout fallback returns null
          }
          interstitialAd.destroy(); // Clean up resources in case of timeout
          return null;
        },
      );
    } catch (e) {
      interstitialAd.destroy(); // Ensure ad destruction on exception
      return null; // Return null as a fallback
    }
  }

  @override
  Future<void> showFacebookRewardAd(String adId) async {
    if (isPro) return; // Skip if user is Pro
    // showAdLoadingDialog();
    meta.RewardedAd? ad = await loadFacebookRewardAd(adId);
    if (ad != null) {
      await ad.show(); // Show the ad if loaded
      ad.destroy(); // Clean up resources after showing
    }
    dismiss(); // Ensure the dialog is dismissed in all cases
  }

  Future<meta.RewardedAd?> loadFacebookRewardAd(String adId) async {
    if (isPro) return null; // Skip loading if user is Pro

    Completer<meta.RewardedAd?> completer = Completer();

    // Create a new interstitial ad instance
    final rewardedAd = meta.RewardedAd(kDebugMode ? meta.RewardedAd.testPlacementId : adId);

    // Attach event listeners
    rewardedAd.listener = meta.RewardedAdListener(
      onLoaded: () {
        if (!completer.isCompleted) {
          completer.complete(rewardedAd); // Complete with the loaded ad
        }
      },
      onError: (code, error) {
        if (!completer.isCompleted) {
          completer.complete(null); // Complete with null on error
        }
        rewardedAd.destroy(); // Destroy the ad to release resources
      },
      onVideoComplete: () {
        rewardedAd.destroy();
        FirebaseAnalytics.instance.logAdImpression();
      },
      onVideoClosed: rewardedAd.destroy,
    );

    // Attempt to load the ad
    rewardedAd.load();

    try {
      return await completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete(null); // Timeout fallback returns null
          }
          rewardedAd.destroy(); // Clean up resources in case of timeout
          return null;
        },
      );
    } catch (e) {
      rewardedAd.destroy(); // Ensure ad destruction on exception
      return null; // Return null as a fallback
    }
  }

  @override
  Widget getFacebookBannerWidget(AdModel? ad) {
    Widget adWidget = const SizedBox.shrink();
    // if ad is not null and active and type is interstitial
    if (ad != null && ad.active) {
      String adId = _getAdId(ad);

      if (ad.type == AdType.banner) {
        adWidget = meta.BannerAd(
          placementId: kDebugMode ? meta.BannerAd.testPlacementId : adId,
          bannerSize: meta.BannerSize.STANDARD,
          listener: meta.BannerAdListener(
            onLoggingImpression: FirebaseAnalytics.instance.logAdImpression,
          ),
        );
      } else if (ad.type == AdType.native) {
        adWidget = meta.NativeAd(
          placementId: kDebugMode ? meta.NativeAd.testPlacementId : adId,
          adType: meta.NativeAdType.NATIVE_AD,
          width: double.infinity,
          height: 300,
          backgroundColor: primaryColor,
          titleColor: Colors.white,
          descriptionColor: Colors.white,
          buttonColor: primaryColor,
          buttonTitleColor: Colors.white,
          buttonBorderColor: Colors.white,
          keepAlive: true,
          keepExpandedWhileLoading: true,
          expandAnimationDuraion: 300,
          listener: meta.NativeAdListener(
            onLoggingImpression: FirebaseAnalytics.instance.logAdImpression,
          ),
        );
      }
    }
    return adWidget;
  }

  @override
  Future<meta.InterstitialAd?> showAppOpenFacebook(String adId) async {
    if (isPro) return null; // Skip if user is Pro
    return await loadFacebookInterstitial(adId);
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

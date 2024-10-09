import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../common/snackbar.dart';
import '../utils/ads.dart';
import '../view/base/ad_loading_dialog.dart';
import '../view/base/ad_placeholder.dart';
import 'subscription_controller.dart';

class AdsController extends GetxController implements GetxService {
  static AdsController get find => Get.find<AdsController>();

  final Map<String, bool> _adStatus = {};

  // Future<String> getAdIds() async {
  //   final response = await adRepo.getAdIds();
  //   if (response != null) {
  //     final data = jsonDecode(response.body)['data'];
  //     List<AdModel> ads = [];
  //     for (var item in data) {
  //       ads.add(AdModel.fromJson(item));
  //     }
  //     for (var ad in ads) {
  //       switch (ad.type) {
  //         case 'app_open':
  //           appOpenAdId = ad.adId;
  //           _adStatus[appOpenAdId] = ad.status == 1;
  //           break;
  //         case 'reward':
  //           rewardVideAdId = ad.adId;
  //           _adStatus[rewardVideAdId] = ad.status == 1;
  //           break;
  //         case 'interstitial':
  //           interstitialAdId = ad.adId;
  //           _adStatus[interstitialAdId] = ad.status == 1;
  //           break;
  //       }
  //     }
  //   }
  //   return 'done';
  // }

  void setAdStatus() {
    _adStatus[AdIds.APP_OPEN_ID] = true;
    _adStatus[AdIds.ONGENERATE_INTERSTITIAL_ID] = true;
    _adStatus[AdIds.ONGENERATE_REWARD_AD_ID] = true;
  }

  bool isAdIdActive(String adId) {
    return _adStatus[adId] ?? false;
  }

  void initialize() {
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(params, () {
      ConsentInformation.instance.isConsentFormAvailable().then((value) {
        loadForm();
      });
    }, (error) {});
  }

  void loadForm() {
    ConsentForm.loadConsentForm((consentForm) async {
      if (await ConsentInformation.instance.getConsentStatus() ==
          ConsentStatus.required) {
        consentForm.show((formError) {});
      }
    }, (formError) {});
  }

  // show on generate interstitial ad
  Future<void> showOnGenerateInterstitial() async {
    String adId = AdIds.ONGENERATE_INTERSTITIAL_ID;
    bool isAdAvailable = isAdIdActive(adId);
    if (!isAdAvailable) {
      return;
    }
    showAdLoadingDialog();
    InterstitialAd? interstitialAd = await loadInterstitial(adId);
    if (interstitialAd != null) {
      await interstitialAd.show();
    }
    dismiss();
  }

  Future<void> showOnGenerateRewardVideo() async {
    String adId = AdIds.ONGENERATE_REWARD_AD_ID;
    bool isAdAvailable = isAdIdActive(adId);
    if (!isAdAvailable) {
      return;
    }
    showAdLoadingDialog();
    RewardedAd? rewardedAd = await loadRewardVideoAd(adId);
    if (rewardedAd != null) {
      await rewardedAd.show(onUserEarnedReward: (ad, reward) {
        FirebaseAnalytics.instance.logAdImpression();
      });
    }
    dismiss();
  }

  Future<void> showAppOpen() async {
    String adId = AdIds.APP_OPEN_ID;
    bool isAdAvailable = isAdIdActive(adId);
    if (!isAdAvailable) {
      return;
    }
    AppOpenAd? interstitialAd = await loadOpenAd(adId);
    if (interstitialAd != null) {
      await interstitialAd.show();
    }
  }

  Future<InterstitialAd?> loadInterstitial(String unitId) async {
    if (SubscriptionController.find.isPro) return null;
    Completer<InterstitialAd?> completer = Completer();
    InterstitialAd.load(
      adUnitId: unitId,
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

    // Wait for ad to load or timeout (whichever happens first)
    try {
      return await completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
          return null;
        },
      );
    } catch (e) {
      return null;
    }
  }

  Future<AppOpenAd?> loadOpenAd(String unitId) async {
    if (SubscriptionController.find.isPro) return null;
    Completer<AppOpenAd?> completer = Completer();
    AppOpenAd.load(
      adUnitId: unitId,
      request: AdIds.adRequest,
      adLoadCallback: AppOpenAdLoadCallback(
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
    // Use Future.timeout to enforce a 5-second limit
    try {
      return await completer.future.timeout(const Duration(seconds: 4),
          onTimeout: () {
        if (!completer.isCompleted) {
          completer.complete(); // Complete with null if timeout occurs
        }
        return null; // Return null on timeout
      });
    } catch (e) {
      return null; // Return null in case of any unexpected errors
    }
  }

  // reward video ad
  Future<RewardedAd?> loadRewardVideoAd(String unitId) async {
    Completer<RewardedAd?> completer = Completer();
    RewardedAd.load(
      adUnitId: unitId,
      request: AdIds.adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
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
    // Wait for ad to load or timeout (whichever happens first)
    try {
      return await completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete(); // Complete with null on timeout
          }
          return null; // Return null on timeout
        },
      );
    } catch (e) {
      return null; // Return null on error
    }
  }

  Future<RewardedInterstitialAd?> loadRewardAd(String unitId) async {
    Completer<RewardedInterstitialAd?> completer = Completer();
    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: AdIds.adRequest,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
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
    // Wait for ad to load or timeout (whichever happens first)
    try {
      return await completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete(); // Complete with null on timeout
          }
          return null; // Return null on timeout
        },
      );
    } catch (e) {
      return null; // Return null on error
    }
  }

  static Widget bannerAd(String unitId, {AdSize adsize = AdSize.banner}) {
    var banner = BannerAd(
      adUnitId: unitId,
      size: adsize,
      listener: BannerAdListener(
        onAdImpression: (ad) {
          FirebaseAnalytics.instance.logAdImpression();
        },
      ),
      request: const AdRequest(extras: {"collapsible": "bottom"}),
    );
    return GetBuilder<SubscriptionController>(
      builder: (con) => con.isPro
          ? const SizedBox.shrink()
          : SizedBox(
              key: Key(unitId),
              height: adsize.height.toDouble(),
              width: adsize.width.toDouble(),
              child: FutureBuilder(
                future: banner.load(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const BannerAdPlaceholder();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return AdWidget(ad: banner);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
    );
  }
}

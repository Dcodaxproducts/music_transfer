import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../controller/subscription_controller.dart';
import '../../view/base/ad_loading_dialog.dart';
import '../../utils/ads.dart';
import '../../common/snackbar.dart';
import 'ads_service_interface.dart';

class AdsService implements AdsServiceInterface {
  final Map<String, bool> _adStatus = {};

  @override
  void setAdStatus() {
    _adStatus[AdIds.APP_OPEN_ID] = true;
    _adStatus[AdIds.ONGENERATE_INTERSTITIAL_ID] = true;
    _adStatus[AdIds.ONGENERATE_REWARD_AD_ID] = true;
  }

  bool _isAdIdActive(String adId) {
    return _adStatus[adId] ?? false;
  }

  @override
  void initialize() {
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(params, () {
      ConsentInformation.instance.isConsentFormAvailable().then((value) {
        loadForm();
      });
    }, (error) {
      showSnack("Consent initialization failed: $error");
    });
  }

  @override
  void loadForm() {
    ConsentForm.loadConsentForm((consentForm) async {
      if (await ConsentInformation.instance.getConsentStatus() ==
          ConsentStatus.required) {
        consentForm.show((formError) {
          if (formError != null) {
            showSnack("Consent form error: $formError");
          }
        });
      }
    }, (formError) {
      showSnack("Failed to load consent form: $formError");
    });
  }

  @override
  Future<void> showOnGenerateInterstitial() async {
    String adId = AdIds.ONGENERATE_INTERSTITIAL_ID;
    bool isAdAvailable = _isAdIdActive(adId);
    if (!isAdAvailable) return;

    showAdLoadingDialog();
    InterstitialAd? interstitialAd = await _loadInterstitial(adId);
    if (interstitialAd != null) {
      await interstitialAd.show();
    }
    dismiss();
  }

  @override
  Future<void> showOnGenerateRewardVideo() async {
    String adId = AdIds.ONGENERATE_REWARD_AD_ID;
    bool isAdAvailable = _isAdIdActive(adId);
    if (!isAdAvailable) return;

    showAdLoadingDialog();
    RewardedAd? rewardedAd = await _loadRewardVideoAd(adId);
    if (rewardedAd != null) {
      await rewardedAd.show(onUserEarnedReward: (ad, reward) {
        FirebaseAnalytics.instance.logAdImpression();
      });
    }
    dismiss();
  }

  @override
  Future<void> showAppOpen() async {
    String adId = AdIds.APP_OPEN_ID;
    bool isAdAvailable = _isAdIdActive(adId);
    if (!isAdAvailable) return;

    AppOpenAd? appOpenAd = await _loadOpenAd(adId);
    if (appOpenAd != null) {
      await appOpenAd.show();
    }
  }

  Future<InterstitialAd?> _loadInterstitial(String unitId) async {
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

    try {
      return await completer.future.timeout(const Duration(seconds: 4),
          onTimeout: () {
        if (!completer.isCompleted) completer.complete();
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<AppOpenAd?> _loadOpenAd(String unitId) async {
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
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      return await completer.future.timeout(const Duration(seconds: 4),
          onTimeout: () {
        if (!completer.isCompleted) completer.complete();
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<RewardedAd?> _loadRewardVideoAd(String unitId) async {
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
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      return await completer.future.timeout(const Duration(seconds: 4),
          onTimeout: () {
        if (!completer.isCompleted) completer.complete();
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  void showSnack(String text) {
    showToast(text, success: false);
  }
}

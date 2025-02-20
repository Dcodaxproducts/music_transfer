import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/data/repository/ad_repo_interface.dart';
import 'package:matrix_ai/data/utils/firebase_events.dart';
import 'package:matrix_ai/imports.dart';
import '../../controller/subscription_controller.dart';
import '../../view/base/ads/native_ad.dart';
import '../model/response/ad_model.dart';
import 'ads_service_interface.dart';
import 'package:easy_audience_network/easy_audience_network.dart' as meta;

class AdsService implements AdsServiceInterface {
  final AdRepoInterface adRepo;
  AdsService({required this.adRepo});

  @override
  Future<List<AdModel>> getAdIds() async {
    final response = await adRepo.getAdIds();
    if (response == null) return [];

    final data = jsonDecode(response.body)['ads'];
    return data.map<AdModel>((item) => AdModel.fromJson(item)).toList();
  }

  @override
  void initialize() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => ConsentInformation.instance.isConsentFormAvailable().then((_) => loadForm()),
      (error) {},
    );
  }

  @override
  void loadForm() {
    ConsentForm.loadConsentForm((consentForm) async {
      if (await ConsentInformation.instance.getConsentStatus() == ConsentStatus.required) {
        consentForm.show((formError) {});
      }
    }, (formError) {});
  }

  @override
  Future<bool> showInterstitial(String adId) async {
    if (SubscriptionController.find.isPro) return false;

    if (Platform.isAndroid) {
      return await _showFacebookInterstitial(adId);
    }

    InterstitialAd? interstitialAd = await adRepo.loadAd<InterstitialAd>(adId);
    if (interstitialAd != null) {
      interstitialAd.fullScreenContentCallback = adRepo.getFullScreenContentCallback<InterstitialAd>();
      await interstitialAd.show();
      return true;
    }
    return false;
  }

  @override
  Future<bool> showRewardInterstitial(String adId, {Function()? onUserEarnedReward}) async {
    if (SubscriptionController.find.isPro) return false;

    if (Platform.isAndroid) {
      return await _showFacebookRewardAd(adId);
    }

    RewardedInterstitialAd? rewardedInterstitialAd = await adRepo.loadAd<RewardedInterstitialAd>(adId);
    if (rewardedInterstitialAd != null) {
      rewardedInterstitialAd.fullScreenContentCallback =
          adRepo.getFullScreenContentCallback<RewardedInterstitialAd>();
      await rewardedInterstitialAd.show(onUserEarnedReward: (ad, reward) {
        onUserEarnedReward?.call();
        FirebaseAnalytics.instance.logAdImpression();
      });
      return true;
    }
    return false;
  }

  @override
  Future<bool> showRewardVideo(String adId, {Function()? onUserEarnedReward}) async {
    if (SubscriptionController.find.isPro) return false;

    if (Platform.isAndroid) {
      return await _showFacebookInterstitial(adId);
    }

    RewardedAd? rewardedAd = await adRepo.loadAd<RewardedAd>(adId);
    if (rewardedAd != null) {
      rewardedAd.fullScreenContentCallback = adRepo.getFullScreenContentCallback<RewardedAd>();
      await rewardedAd.show(onUserEarnedReward: (ad, reward) {
        onUserEarnedReward?.call();
        FirebaseAnalytics.instance.logAdImpression();
      });
      return true;
    }
    return false;
  }

  @override
  Future<bool> showAppOpen(String adId) async {
    if (SubscriptionController.find.isPro) return false;

    if (Platform.isAndroid) {
      return await _showFacebookInterstitial(adId);
    }

    AppOpenAd? appOpenAd = await adRepo.loadAd<AppOpenAd>(adId);
    if (appOpenAd != null) {
      appOpenAd.fullScreenContentCallback = adRepo.getFullScreenContentCallback<AppOpenAd>();
      await appOpenAd.show();
      return true;
    }
    return false;
  }

  @override
  Widget getBannerWidget(AdModel? ad) {
    if (Platform.isAndroid) return getFacebookBannerWidget(ad);
    if (ad == null || !ad.active || SubscriptionController.find.isPro) return const SizedBox.shrink();
    String adId = ad.getAdId();
    if (ad.type == AdType.banner) {
      return FutureBuilder(
        future: AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.sizeOf(Get.context!).width.truncate(),
        ),
        builder: (context, snapshot) =>
            snapshot.hasData ? BannerAdWidget(adId: adId, adSize: snapshot.data as AdSize) : const SizedBox(),
      );
    } else if (ad.type == AdType.nativeMedium) {
      return NativeAdWidget(adId: adId, templateType: TemplateType.medium);
    } else if (ad.type == AdType.nativeSmall) {
      return NativeAdWidget(adId: adId, templateType: TemplateType.small);
    }
    return const SizedBox.shrink();
  }

  // Facebook Ads

  Future<bool> _showFacebookInterstitial(String adId) async {
    if (isPro) return false;
    meta.InterstitialAd? interstitialAd = await adRepo.loadAd<meta.InterstitialAd>(adId);
    if (interstitialAd != null) {
      await interstitialAd.show();
      return true;
    }
    return false;
  }

  Future<bool> _showFacebookRewardAd(String adId) async {
    if (isPro) return false;
    meta.RewardedAd? rewardedAd = await adRepo.loadAd<meta.RewardedAd>(adId);
    if (rewardedAd != null) {
      await rewardedAd.show();
      return true;
    }
    return false;
  }

  @override
  Widget getFacebookBannerWidget(AdModel? ad) {
    Widget adWidget = const SizedBox.shrink();
    // if ad is not null and active and type is interstitial
    if (ad != null && ad.active) {
      String adId = ad.getAdId();

      if (ad.type == AdType.banner) {
        adWidget = meta.BannerAd(
          placementId: kDebugMode ? meta.BannerAd.testPlacementId : adId,
          bannerSize: meta.BannerSize.STANDARD,
          listener: meta.BannerAdListener(onLoggingImpression: EventsHelper.logFacebookBannerAdEvent),
        );
      } else if (ad.type == AdType.nativeMedium || ad.type == AdType.nativeSmall) {
        adWidget = meta.NativeAd(
          placementId: kDebugMode ? meta.NativeAd.testPlacementId : adId,
          adType: meta.NativeAdType.NATIVE_AD,
          width: double.infinity,
          bannerAdSize: meta.NativeBannerAdSize.HEIGHT_100,
          backgroundColor: primaryColor,
          titleColor: Colors.white,
          descriptionColor: Colors.white,
          buttonColor: primaryColor,
          buttonTitleColor: Colors.white,
          buttonBorderColor: Colors.white,
          keepAlive: true,
          keepExpandedWhileLoading: true,
          expandAnimationDuraion: 300,
          listener: meta.NativeAdListener(onLoggingImpression: EventsHelper.logFacebookNativeAdEvent),
        );
      }
    }
    return adWidget;
  }

  void showSnack(String text) {
    showToast(text, success: false);
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/data/service/ads_service_interface.dart';
import '../data/model/response/ad_model.dart';
import '../data/model/response/model.dart';
import 'subscription_controller.dart';

class AdsController extends GetxController {
  final AdsServiceInterface adsService;
  AdsController({required this.adsService});

  static AdsController get find => Get.find<AdsController>();

  List<AdModel> _ads = [];
  List<AdModel> get ads => _ads;
  set ads(List<AdModel> value) {
    _ads = value;
    update();
  }

  Future<void> initialize() async {
    if (!isPro) {
      if (Platform.isIOS) {
        adsService.initialize();
      }
      ads = await adsService.getAdIds();
    }
  }

  Future<AppOpenAd?> showAppOpenAd() async {
    AppOpenAd? appOpenAd;
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.appOpen);

    // if ad is not null and active and type is appOpen
    if (ad != null && ad.type == AdType.appOpen && ad.active) {
      String adId = _getAdId(ad);
      appOpenAd = await adsService.showAppOpen(adId);
    }
    return appOpenAd;
  }

  Future<void> showOnGenerateVideo() async {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.onGenerateVideo);

    // if ad is not null and active and type is reward
    if (ad != null && ad.active) {
      String adId = _getAdId(ad);
      if (ad.type == AdType.reward) {
        await adsService.showRewardVideo(adId);
      }
      if (ad.type == AdType.rewardedInterstitial) {
        await adsService.showRewardInterstitial(adId);
      }
    }
  }

  Future<dynamic> getOnGenerateVideo() async {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.onGenerateVideo);

    // if ad is not null and active and type is reward
    if (ad != null && ad.active) {
      String adId = _getAdId(ad);
      if (ad.type == AdType.reward) {
        return await adsService.loadRewardVideoAd(adId);
      }
      if (ad.type == AdType.rewardedInterstitial) {
        return await adsService.loadRewardInterstitialAd(adId);
      }
    }
    return null;
  }

  Future<void> showOnGenerateInterstitial() async {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.onGenerateInterstitial);

    // if ad is not null and active and type is interstitial
    if (ad != null && ad.type == AdType.interstital && ad.active) {
      String adId = _getAdId(ad);
      await adsService.showInterstitial(adId);
    }
  }

  Widget showModelScreenAd() {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.modelScreen);

    return adsService.getBannerWidget(ad);
  }

  Widget showPromptSettingAd() {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.promptSettingScreen);

    return adsService.getBannerWidget(ad);
  }

  Widget showHistoryScreenAd() {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.historyScreen);

    return adsService.getBannerWidget(ad);
  }

  Widget showResultScreenAd() {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.resultScreen);

    return adsService.getBannerWidget(ad);
  }

  Widget showLanguageScreenAd() {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.languageScreen);

    return adsService.getBannerWidget(ad);
  }

  Widget showInspirationScreenAd() {
    // get ad
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == AdPosition.inspirationScreen);

    return adsService.getBannerWidget(ad);
  }

  _getAdId(AdModel ad) {
    return Platform.isAndroid ? ad.androidAdId : ad.iosAdId;
  }
}

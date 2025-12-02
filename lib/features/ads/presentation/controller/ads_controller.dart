import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixart_app/features/ads/domain/service/ads_service_interface.dart';
import '../../data/enum/ad_position.dart';
import '../../data/enum/ad_type.dart';
import '../../data/model/ad_model.dart';
import '../../../subscription/presentation/controller/subscription_controller.dart';

class AdsController extends GetxController {
  final AdsServiceInterface adsService;
  AdsController({required this.adsService});

  static AdsController get find => Get.find<AdsController>();

  List<AdModel> _ads = [];
  bool _adShowing = false;

  List<AdModel> get ads => _ads;
  bool get adShowing => _adShowing;

  set ads(List<AdModel> value) {
    _ads = value;
    update();
  }

  set adShowing(bool value) {
    _adShowing = value;
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

  Future<bool> showAppOpenAd() async {
    return await _showAd(AdPosition.appOpen);
  }

  Future<bool> showOnGenerateVideo() async {
    return await _showAd(AdPosition.onGenerateVideo);
  }

  Future<bool> showOnGenerateInterstitial() async {
    return await _showAd(AdPosition.onGenerateInterstitial);
  }

  Widget buildModelScreenAd() {
    return _buildAdWidget(AdPosition.modelScreen);
  }

  Widget buildPromptSettingAd() {
    return _buildAdWidget(AdPosition.promptSettingScreen);
  }

  Widget buildHistoryScreenAd() {
    return _buildAdWidget(AdPosition.historyScreen);
  }

  Widget buildResultScreenAd() {
    return _buildAdWidget(AdPosition.resultScreen);
  }

  Widget buildLanguageScreenAd() {
    return _buildAdWidget(AdPosition.languageScreen);
  }

  Widget buildInspirationScreenAd() {
    return _buildAdWidget(AdPosition.inspirationScreen);
  }

  Widget _buildAdWidget(AdPosition position) {
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == position);
    return adsService.getBannerWidget(ad);
  }

  Future<bool> _showAd(AdPosition position, {Function()? onUserEarnedReward}) async {
    AdModel? ad = ads.firstWhereOrNull((element) => element.position == position);
    if (ad != null && ad.active) {
      String adId = ad.getAdId();
      return await _showAdAccordingToType(ad.type, adId, onUserEarnedReward: onUserEarnedReward);
    }
    return false;
  }

  Future<bool> _showAdAccordingToType(AdType? type, String adId, {Function()? onUserEarnedReward}) async {
    if (type == AdType.interstitial) {
      return await adsService.showInterstitial(adId);
    } else if (type == AdType.rewardedInterstitial) {
      return await adsService.showRewardInterstitial(adId, onUserEarnedReward: onUserEarnedReward);
    } else if (type == AdType.reward) {
      return await adsService.showRewardVideo(adId, onUserEarnedReward: onUserEarnedReward);
    } else if (type == AdType.appOpen) {
      return await adsService.showAppOpen(adId);
    }
    return false;
  }
}

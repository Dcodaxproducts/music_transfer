import 'dart:io';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/utils/ads.dart';

class AdModel {
  int id;
  AdType? type;
  bool active;
  String androidAdId;
  String iosAdId;
  AdPosition position;

  AdModel({
    required this.id,
    required this.type,
    required this.active,
    required this.androidAdId,
    required this.iosAdId,
    required this.position,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      type: AdTypeExtension.fromString(
          GetPlatform.isAndroid ? json['type'] : (json['ios_type'] ?? json['type'])),
      active: Platform.isAndroid ? json['status'] == 1 : json['ios_status'] == 1,
      androidAdId: json['android_ad_id'] ?? '',
      iosAdId: json['ios_ad_id'] ?? '',
      position: AdPositionExtension.fromString(json['position']),
    );
  }

  String getAdId() {
    bool isAndroid = GetPlatform.isAndroid;
    String adId = '';
    adId = isAndroid ? androidAdId : iosAdId;
    if (kDebugMode) {
      switch (type) {
        case AdType.banner:
          adId = isAndroid ? BannerAd.testPlacementId : AdIds.BANNER_ID;
          break;
        case AdType.nativeMedium:
          adId = isAndroid ? NativeAd.testPlacementId : AdIds.NATIVE_AD_ID;
          break;
        case AdType.nativeSmall:
          adId = isAndroid ? NativeAd.testPlacementId : AdIds.NATIVE_AD_ID;
          break;
        case AdType.interstitial:
          adId = isAndroid ? InterstitialAd.testPlacementId : AdIds.INTERSTITIAL_ID;
          break;
        case AdType.rewardedInterstitial:
          adId = isAndroid ? InterstitialAd.testPlacementId : AdIds.REWARD_INTERSTITIAL_AD_ID;
          break;
        case AdType.reward:
          adId = isAndroid ? RewardedAd.testPlacementId : AdIds.REWARD_VIDEO_AD_ID;
          break;
        case AdType.appOpen:
          adId = isAndroid ? InterstitialAd.testPlacementId : AdIds.APP_OPEN_ID;
          break;
        default:
          adId = AdIds.BANNER_ID;
          break;
      }
    }
    return adId;
  }
}

// ad position
enum AdPosition {
  appOpen,
  modelScreen,
  promptSettingScreen,
  resultScreen,
  historyScreen,
  inspirationScreen,
  onGenerateVideo,
  onGenerateInterstitial,
  languageScreen,
}

extension AdPositionExtension on AdPosition {
  static AdPosition fromString(String value) {
    switch (value) {
      case 'app_open':
        return AdPosition.appOpen;
      case 'model_screen':
        return AdPosition.modelScreen;
      case 'prompt_setting_screen':
        return AdPosition.promptSettingScreen;
      case 'result_screen':
        return AdPosition.resultScreen;
      case 'history_screen':
        return AdPosition.historyScreen;
      case 'inspiration_screen':
        return AdPosition.inspirationScreen;
      case 'on_generate_video':
        return AdPosition.onGenerateVideo;
      case 'on_generate_interstitial':
        return AdPosition.onGenerateInterstitial;
      case 'language_screen':
        return AdPosition.languageScreen;
      default:
        return AdPosition.appOpen;
    }
  }
}

// Ad type
enum AdType { appOpen, reward, interstitial, rewardedInterstitial, banner, nativeMedium, nativeSmall }

extension AdTypeExtension on AdType {
  static AdType? fromString(String? value) {
    switch (value) {
      case 'reward':
        return AdType.reward;
      case 'rewarded_interstitial':
        return AdType.rewardedInterstitial;
      case 'interstitial':
        return AdType.interstitial;
      case 'banner':
        return AdType.banner;
      case 'app_open':
        return AdType.appOpen;
      case 'native':
        return AdType.nativeMedium;
      case 'native_medium':
        return AdType.nativeMedium;
      case 'native_small':
        return AdType.nativeSmall;
      default:
        return null;
    }
  }
}

import 'dart:io';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/ads/data/utils/ads.dart';
import '../enum/ad_type.dart';
import '../enum/ad_position.dart';
import '../extension/ad_position.dart';
import '../extension/ad_type.dart';

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
        GetPlatform.isAndroid ? json['type'] : (json['ios_type'] ?? json['type']),
      ),
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

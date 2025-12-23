import 'package:flutter/material.dart';
import 'package:pixart_app/features/ads/data/model/ad_model.dart';

abstract class AdsServiceInterface {
  Future<List<AdModel>> getAdIds();
  void initialize();
  void loadForm();
  Future<bool> showInterstitial(String adId);
  Future<bool> showRewardInterstitial(
    String adId, {
    Function()? onUserEarnedReward,
  });
  Future<bool> showRewardVideo(String adId, {Function()? onUserEarnedReward});
  Future<bool> showAppOpen(String adId);
  Widget getBannerWidget(AdModel? ad);
  Widget getFacebookBannerWidget(AdModel? ad);
}

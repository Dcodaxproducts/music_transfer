import 'dart:async';
import 'package:get/get.dart';
import 'package:matrix_ai/data/service/ads_service_interface.dart';
import 'subscription_controller.dart';

class AdsController extends GetxController {
  final AdsServiceInterface adsService;
  AdsController({required this.adsService});

  static AdsController get find => Get.find<AdsController>();

  void initialize() {
    if (!isPro) {
      adsService.initialize();
      adsService.setAdStatus();
    }
  }

  Future<void> showInterstitialAd() async {
    if (isPro) return;
    await adsService.showOnGenerateInterstitial();
  }

  Future<void> showRewardVideoAd() async {
    if (isPro) return;
    await adsService.showOnGenerateRewardVideo();
  }

  Future<void> showAppOpenAd() async {
    if (isPro) return;
    await adsService.showAppOpen();
  }
}

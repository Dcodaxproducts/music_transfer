import 'dart:async';
import 'dart:convert';
import 'package:pixart_app/features/ads/data/repository/ad_repo.dart';
import 'package:pixart_app/imports.dart';
import '../../../paywall/presentation/controller/subscription_controller.dart';
import '../../data/enum/ad_type.dart';
import '../../presentation/view/native_ad.dart';
import '../../data/model/ad_model.dart';
import 'ads_service_interface.dart';

class AdsService implements AdsServiceInterface {
  final AdRepo adRepo;
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

    RewardedInterstitialAd? rewardedInterstitialAd = await adRepo.loadAd<RewardedInterstitialAd>(adId);
    if (rewardedInterstitialAd != null) {
      rewardedInterstitialAd.fullScreenContentCallback = adRepo
          .getFullScreenContentCallback<RewardedInterstitialAd>();
      await rewardedInterstitialAd.show(
        onUserEarnedReward: (ad, reward) {
          onUserEarnedReward?.call();
        },
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> showRewardVideo(String adId, {Function()? onUserEarnedReward}) async {
    if (SubscriptionController.find.isPro) return false;

    RewardedAd? rewardedAd = await adRepo.loadAd<RewardedAd>(adId);
    if (rewardedAd != null) {
      rewardedAd.fullScreenContentCallback = adRepo.getFullScreenContentCallback<RewardedAd>();
      await rewardedAd.show(
        onUserEarnedReward: (ad, reward) {
          onUserEarnedReward?.call();
        },
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> showAppOpen(String adId, {Function()? onAdDismissed}) async {
    if (SubscriptionController.find.isPro) return false;

    AppOpenAd? appOpenAd = await adRepo.loadAd<AppOpenAd>(adId);
    if (appOpenAd != null) {
      appOpenAd.fullScreenContentCallback = adRepo.getFullScreenContentCallback<AppOpenAd>(
        onAdDismissed: onAdDismissed,
      );

      await appOpenAd.show();
      return true;
    }
    return false;
  }

  @override
  Widget getBannerWidget(AdModel? ad) {
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
}

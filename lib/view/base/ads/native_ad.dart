import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/data/utils/firebase_events.dart';
import '../../../controller/subscription_controller.dart';
import 'ad_placeholder.dart';

class NativeAdWidget extends StatefulWidget {
  final String adId;
  const NativeAdWidget({super.key, required this.adId});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  late NativeAd _ad;
  bool isLoaded = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (SubscriptionController.find.isPro) return;
    loadNativeAd();
  }

  ///Important make sure to dispose the ad when disposing the screen
  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  void loadNativeAd() {
    _ad = NativeAd(
      request: const AdRequest(),

      ///This is a test adUnitId make sure to change it
      adUnitId: widget.adId,
      factoryId: 'listTile',
      listener: NativeAdListener(onAdLoaded: (ad) {
        setState(() {
          isLoaded = true;
          isLoading = false;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        setState(() {
          isLoading = false;
        });
      }, onAdImpression: (ad) {
        EventsHelper.logGoogleBannerAdEvent();
      }),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (con) {
      return con.isPro
          ? const SizedBox.shrink()
          : isLoaded
              ? Container(
                  alignment: Alignment.center,
                  height: 170,
                  color: Colors.white,
                  child: AdWidget(
                    ad: _ad,
                  ),
                )
              : isLoading
                  ? const NativeAdPlaceholder()
                  : const SizedBox.shrink();
    });
  }
}

class BannerAdWidget extends StatefulWidget {
  final String adId;
  final AdSize adSize;
  const BannerAdWidget({super.key, required this.adId, required this.adSize});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _ad;
  bool isLoaded = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (SubscriptionController.find.isPro) return;
    loadNativeAd();
  }

  ///Important make sure to dispose the ad when disposing the screen
  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  void loadNativeAd() {
    _ad = BannerAd(
      size: widget.adSize,
      request: const AdRequest(),
      adUnitId: widget.adId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isLoaded = true;
          isLoading = false;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        setState(() {
          isLoading = false;
        });
      }, onAdImpression: (ad) {
        EventsHelper.logGoogleNativeAdEvent();
      }),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (con) {
      return con.isPro
          ? const SizedBox.shrink()
          : isLoaded
              ? Container(
                  alignment: Alignment.center,
                  height: widget.adSize.height.truncateToDouble(),
                  width: widget.adSize.width.truncateToDouble(),
                  color: Colors.white,
                  child: AdWidget(ad: _ad),
                )
              : isLoading
                  ? BannerAdPlaceholder(
                      width: widget.adSize.width.truncateToDouble(),
                      height: widget.adSize.height.truncateToDouble(),
                    )
                  : const SizedBox.shrink();
    });
  }
}

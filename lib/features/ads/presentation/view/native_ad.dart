import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../subscription/presentation/controller/subscription_controller.dart';
import 'ad_placeholder.dart';

class NativeAdWidget extends StatefulWidget {
  final String adId;
  final TemplateType? templateType;
  const NativeAdWidget({super.key, required this.adId, this.templateType});
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
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
            isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            isLoading = false;
          });
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(templateType: widget.templateType ?? TemplateType.small),
    );
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.templateType == TemplateType.medium ? 250 : 120;
    return GetBuilder<SubscriptionController>(builder: (con) {
      return con.isPro
          ? const SizedBox.shrink()
          : isLoaded
              ? SizedBox(height: height, width: double.infinity, child: AdWidget(ad: _ad))
              : isLoading
                  ? NativeAdPlaceholder(height: height)
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
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
            isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            isLoading = false;
          });
        },
      ),
    );
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.adSize.height.truncateToDouble();
    final double width = widget.adSize.width.truncateToDouble();
    return GetBuilder<SubscriptionController>(builder: (con) {
      return con.isPro
          ? const SizedBox.shrink()
          : isLoaded
              ? SizedBox(height: height, width: width, child: AdWidget(ad: _ad))
              : isLoading
                  ? BannerAdPlaceholder(width: width, height: height)
                  : const SizedBox.shrink();
    });
  }
}

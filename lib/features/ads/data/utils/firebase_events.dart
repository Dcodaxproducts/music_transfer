import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:pixart_app/imports.dart';

class EventsHelper {
  static final EventsHelper _instance = EventsHelper._internal();

  factory EventsHelper() => _instance;

  EventsHelper._internal();

  final String _googleInterstitalAdEvent = 'google_interstitial_ad';
  final String _googleRewardedInterstitalAdEvent = 'google_reward_interstitial_ad';
  final String _googleRewardedAdEvent = 'google_rewarded_ad';
  final String _googleAppOpenAdEvent = 'google_app_open_ad';
  final String _googleBannerAdEvent = 'google_banner_ad';
  final String _googleNativeAdEvent = 'google_native_ad';

  final String _facebookInterstitalAdEvent = 'facebook_interstitial_ad';
  final String _facebookBannerAdEvent = 'facebook_banner_ad';
  final String _facebookNativeAdEvent = 'facebook_native_ad';

  void _logGoogleInterstitialAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'google',
      adFormat: _googleInterstitalAdEvent,
    );
  }

  void _logGoogleRewardedInterstitialAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'google',
      adFormat: _googleRewardedInterstitalAdEvent,
    );
  }

  void _logGoogleBannerAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'google',
      adFormat: _googleBannerAdEvent,
    );
  }

  void _logGoogleNativeAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'google',
      adFormat: _googleNativeAdEvent,
    );
  }

  void _logGoogleRewardedAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'google',
      adFormat: _googleRewardedAdEvent,
    );
  }

  void _logGoogleAppOpenAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'google',
      adFormat: _googleAppOpenAdEvent,
    );
  }

  void _logFacebookInterstitialAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'facebook',
      adFormat: _facebookInterstitalAdEvent,
    );
  }

  void _logFacebookBannerAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'facebook',
      adFormat: _facebookBannerAdEvent,
    );
  }

  void _logFacebookNativeAdEvent() {
    FirebaseAnalytics.instance.logAdImpression(
      adPlatform: GetPlatform.isAndroid ? 'android' : 'iOS',
      adSource: 'facebook',
      adFormat: _facebookNativeAdEvent,
    );
  }

  static void logGoogleInterstitialAdEvent() {
    _instance._logGoogleInterstitialAdEvent();
  }

  static void logGoogleRewardedInterstitialAdEvent() {
    _instance._logGoogleRewardedInterstitialAdEvent();
  }

  static void logGoogleBannerAdEvent() {
    _instance._logGoogleBannerAdEvent();
  }

  static void logGoogleNativeAdEvent() {
    _instance._logGoogleNativeAdEvent();
  }

  static void logGoogleRewardedAdEvent() {
    _instance._logGoogleRewardedAdEvent();
  }

  static void logGoogleAppOpenAdEvent() {
    _instance._logGoogleAppOpenAdEvent();
  }

  static void logFacebookInterstitialAdEvent() {
    _instance._logFacebookInterstitialAdEvent();
  }

  static void logFacebookBannerAdEvent() {
    _instance._logFacebookBannerAdEvent();
  }

  static void logFacebookNativeAdEvent() {
    _instance._logFacebookNativeAdEvent();
  }

  static void logEvent(String name, Map<String, Object> parameters) {
    FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }
}

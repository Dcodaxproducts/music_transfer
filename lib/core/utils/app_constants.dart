import 'dart:io';

class AppConstants {
  // app name and package name
  static const String appName = 'PixArt';
  static const String bundleId = 'pixart.aiart.generator';

  /* App Share link */
  static String appLink = Platform.isAndroid ? androidAppUrl : iOSAppUrl;
  static const String androidAppUrl = "https://play.google.com/store/apps/details?id=$bundleId";
  static const String iOSAppUrl = "https://apps.apple.com/app/pixart-the-ai-art-generator/id6737462382";

  /* manage subscription link */
  static String subscriptionsUrl = Platform.isAndroid ? androidSubscriptionsUrl : iOSSubscriptionUrl;

  static const String androidSubscriptionsUrl = 'https://play.google.com/store/account/subscriptions';
  static const String iOSSubscriptionUrl = 'https://apps.apple.com/account/subscriptions';

  /* Privacy and terms Url's */
  static const String privacy = 'https://sites.google.com/view/privacypoliciesai?usp=sharing';
  static const String terms = 'https://sites.google.com/view/pixart-terms-and-conditions?usp=sharing';
}

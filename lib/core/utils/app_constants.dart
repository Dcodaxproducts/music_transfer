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
  static String manageSubscriptionsUrl = Platform.isAndroid
      ? manageSubscriptionsUrlAndroid
      : manageSubscriptionsUrlIos;

  static const String manageSubscriptionsUrlAndroid = 'https://play.google.com/store/account/subscriptions';
  static const String manageSubscriptionsUrlIos = 'https://apps.apple.com/account/subscriptions';

  /* Privacy and terms Url's */
  static const String privacyPolicy = 'https://pixartai.dcodax.net/privacy-policy';
  static const String termsAndConditions = 'https://pixartai.dcodax.net/terms-condition';

  static const List<String> adultWords = [
    'sex',
    'sexy',
    'nude',
    'nudity',
    'porn',
    'erotic',
    'eroticism',
    'erotic',
    'pornography',
    'pornographic',
    'adult',
    'xxx',
    'nsfw',
    'fuck',
    'dick',
    'vagina',
    'penis',
    'boob',
    'breast',
    'ass',
    'butt',
    'bdsm',
    'hentai',
    'milf',
    'pussy',
    'cock',
    'cum',
    'squirt',
    'orgasm',
    'fetish',
    'hardcore',
    'blowjob',
    'handjob',
    'fingering',
    'anal',
    'slut',
    'whore',
    'prostitute',
    'sextoy',
    'dildo',
    'masturbate',
    'ejaculate',
    'strip',
    'naked',
    'lingerie',
    'bondage',
    'gangbang',
    'threesome',
    'voyeur',
    'swinger',
  ];
}

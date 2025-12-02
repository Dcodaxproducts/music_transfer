// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:io';

class AppConstants {
  // app name and package name
  static const String APP_NAME = 'PixArt';
  static const String APP_PACKAGE_NAME = 'pixart.aiart.generator';

  /* AWS Credientials */
  static const String AWS_ENDPOINT = 's3.amazonaws.com';
  static const String AWS_ACCESS_KEY = 'AKIA4MI2J3YJLGPHFR7L';
  static const String AWS_SECRET_KEY = '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';
  static const String AWS_REGION = 'eu-west-2';
  static const String AWS_BUCKET_NAME = 'matrixart';

  //
  static const int PRO_USER_DAILY_LIMIT = 100;

  /* App Share link */
  static String APP_LINK = Platform.isAndroid ? ANDROID_APP_URL : IOS_APP_URL;
  static const String ANDROID_APP_URL = "https://play.google.com/store/apps/details?id=$APP_PACKAGE_NAME";
  static const String IOS_APP_URL = "https://apps.apple.com/app/pixart-the-ai-art-generator/id6737462382";

  /* manage subscription link */
  static String MANAGE_SUBSCRIPTIONS_URL =
      Platform.isAndroid ? MANAGE_SUBSCRIPTIONS_URL_ANDROID : MANAGE_SUBSCRIPTIONS_URL_IOS;

  static const String MANAGE_SUBSCRIPTIONS_URL_ANDROID =
      'https://play.google.com/store/account/subscriptions';
  static const String MANAGE_SUBSCRIPTIONS_URL_IOS = 'https://apps.apple.com/account/subscriptions';

  /* Privacy and terms Url's */
  static const String PRIVACY_POLICY = 'https://pixartai.dcodax.net/privacy-policy';
  static const String TERMS_AND_CONDITIONS = 'https://pixartai.dcodax.net/terms-condition';

  static const List<String> ADULT_WORDS = [
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

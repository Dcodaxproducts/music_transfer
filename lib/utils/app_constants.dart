// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:io';

import 'package:matrix_ai/data/model/language.dart';

class AppConstants {
  // app name and package name
  static const String APP_NAME = 'PixArt';
  static const String APP_PACKAGE_NAME = 'pixart.aiart.generator';

  // Base URL
  static const String DOMAIN = 'https://pixartai.dcodax.net';
  static const String BASE_URL = '$DOMAIN/api/';

  // API Endpoints
  static const String MODELS_URL = 'ai-models';
  static const String INSIPIRATIONS_URL = 'inspirations';
  static const String FEEDBACK_URL = 'feedback-save';
  static const String CONFIG_URL = 'config';
  static const String GET_ADS = 'ad-list';
  static const String REVIEW = 'review/store';

  // Shared Key
  static const String THEME = 'theme_1';
  static const String COUNTRY_CODE = 'country_code_1';
  static const String LANGUAGE_CODE = 'language_code_1';
  static const String ON_BOARDING_SKIP = 'on_boarding_skip_1';
  static const String NEGATIVE_PROMPT = 'negative_prompt_1';
  static const String GUIDANCE_SCALE = 'guidance_scale_1';
  static const String ASPECT_RATIO = 'aspect_ratio_1';
  static const String SELECTED_MODEL = 'selected_model_1';
  static const String FAVORITE_MODELS = 'favorite_models_1';
  static const String OPEN_COUNT = 'open_count_1';
  static const String PROMPT_HISTORY = 'promptList_1';
  static const String NOTIFICATION = 'notification_1';
  static const String REVIEWED = 'reviewed';
  static const String HAS_VIEWED_ADS_DIALOG = 'has_viewed_ads_dialog_1';
  static const String LAST_DIALOG_SHOWED = 'last_dialog_showed_1';
  static const String SHOW_APP_OPEN = 'show_app_open_1';

  /* App Share link */
  static String APP_LINK = Platform.isAndroid ? ANDROID_APP_URL : IOS_APP_URL;
  static const String ANDROID_APP_URL =
      "https://play.google.com/store/apps/details?id=$APP_PACKAGE_NAME";
  static const String IOS_APP_URL =
      "https://apps.apple.com/app/pixart-the-ai-art-generator/id6737462382";

  /* manage subscription link */
  static String MANAGE_SUBSCRIPTIONS_URL = Platform.isAndroid
      ? MANAGE_SUBSCRIPTIONS_URL_ANDROID
      : MANAGE_SUBSCRIPTIONS_URL_IOS;

  static const String MANAGE_SUBSCRIPTIONS_URL_ANDROID =
      'https://play.google.com/store/account/subscriptions';
  static const String MANAGE_SUBSCRIPTIONS_URL_IOS =
      'https://apps.apple.com/account/subscriptions';

  /* Privacy and terms Url's */
  static const String PRIVACY_POLICY = '$DOMAIN/privacy-policy';
  static const String TERMS_AND_CONDITIONS = '$DOMAIN/terms-condition';

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

  // Language
  static List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      languageName: 'Arabic',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
    LanguageModel(
      languageName: 'Chinese',
      countryCode: 'CN',
      languageCode: 'zh',
    ),
    LanguageModel(
      languageName: 'French',
      countryCode: 'FR',
      languageCode: 'fr',
    ),
    LanguageModel(
      languageName: 'German',
      countryCode: 'DE',
      languageCode: 'de',
    ),
    LanguageModel(
      languageName: 'Indonesian',
      countryCode: 'ID',
      languageCode: 'id',
    ),
    LanguageModel(
      languageName: 'Italian',
      countryCode: 'IT',
      languageCode: 'it',
    ),
    LanguageModel(
      languageName: 'Japanese',
      countryCode: 'JP',
      languageCode: 'ja',
    ),
    LanguageModel(
      languageName: 'Korean',
      countryCode: 'KR',
      languageCode: 'ko',
    ),
    LanguageModel(
      languageName: 'Malay',
      countryCode: 'MY',
      languageCode: 'ms',
    ),
    LanguageModel(
      languageName: 'Portaguese',
      countryCode: 'PT',
      languageCode: 'pt',
    ),
    LanguageModel(
      languageName: 'Russian',
      countryCode: 'RU',
      languageCode: 'ru',
    ),
    LanguageModel(
      languageName: 'Spanish',
      countryCode: 'ES',
      languageCode: 'es',
    ),
    LanguageModel(
      languageName: 'Swedish',
      countryCode: 'SE',
      languageCode: 'sv',
    ),
    LanguageModel(
      languageName: 'Thai',
      countryCode: 'TH',
      languageCode: 'th',
    ),
    LanguageModel(
      languageName: 'Turkish',
      countryCode: 'TR',
      languageCode: 'tr',
    ),
    LanguageModel(
      languageName: 'Romanian',
      countryCode: 'RO',
      languageCode: 'ro',
    ),
    LanguageModel(
      languageName: 'Persian',
      countryCode: 'IR',
      languageCode: 'fa',
    ),
    LanguageModel(
      languageName: 'Vietnamese',
      countryCode: 'VN',
      languageCode: 'vi',
    ),
  ];
}

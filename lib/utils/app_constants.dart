// ignore_for_file: constant_identifier_names

import 'package:matrix_ai/data/model/language.dart';

class AppConstants {
  //
  static const String APP_NAME = 'PixArt';
  static const String APP_PACKAGE_NAME = 'ai.art.photo.generator';

  // API
  static const String DOMAIN = 'https://pixartai.dcodax.net';
  static const String BASE_URL = '$DOMAIN/api/';
  static const String MODELS_URL = 'ai-models';
  static const String INSIPIRATIONS_URL = 'inspirations';
  static const String FEEDBACK_URL = 'feedback-save';
  static const String CONFIG_URL = 'config';
  static const String GET_ADS = 'ad-list';

  static const String APP_URL =
      "https://play.google.com/store/apps/details?id=$APP_PACKAGE_NAME";

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

  /* Privacy and terms Url's */
  static const String PRIVACY_POLICY = '$DOMAIN/privacy-policy';
  static const String TERMS_AND_CONDITIONS = '$DOMAIN/terms-condition';

  /* Subscription Url's */
  static const String cancelSubscriptionUrl =
      'https://play.google.com/store/account/subscriptions?pli=1';
  static const String privacyPolicyUrl =
      'https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldo=0&ldt=privacynotice&ldl=en_GB';
  static const String termsAndConditionsUrl =
      'https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldl=en_GB&ldo=0&ldt=buyertos';

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

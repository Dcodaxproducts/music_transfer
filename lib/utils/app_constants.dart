// ignore_for_file: constant_identifier_names

import 'package:matrix_ai/data/model/body/more_apps.dart';
import 'package:matrix_ai/data/model/language.dart';
import 'package:flutter/foundation.dart';

class AppConstants {
  //
  static const String APP_NAME = 'Matrix AI';
  static const String APP_PACKAGE_NAME = 'ai.art.photo.generator';

  // API
  static const String BASE_URL = 'https://aiart.dcodax.net/api/';
  static const String MODELS_URL = 'ai-models';
  static const String INSIPIRATIONS_URL = 'inspirations';
  static const String FEEDBACK_URL = 'feedback-save';
  static const String PRIVACY_POLICY_URL1 = 'term-and-conditions';
  static const String CONFIG_URL = 'config';

  // Stable Diffusion
  static const String DREAMBOOTH_URL =
      'https://modelslab.com/api/v6/images/text2img';
  static const String QUEUE_URL = 'https://modelslab.com/api/v6/images/fetch';

  // App
  static const String PRIVACY_POLICY_URL =
      "https://doc-hosting.flycricket.io/ai-art-generator/250805ae-7d20-49eb-b777-feb29ba431f4/privacy";

  static const String APP_URL =
      "https://play.google.com/store/apps/details?id=$APP_PACKAGE_NAME";

  static const String API_KEY =
      "Ah9XwMqgVKaQLiMtxykW8SrNsJ0CypVEyyrudFINjH1yWij7SFZ35c7egoaI";

  static const int FREE_GENERATIONS = 10;

  // width: Width of the generated image. height will be calculated from selcted aspect ratio.
  static const double BASE_WIDTH = 512;

  static const double MAX_HEIGHT = 512;

  // samples: Number of images to be returned in response. The maximum value is 4.
  static const String SAMPLES = '1';

  // safety_checker: A checker for NSFW images. If such an image is detected, it will be replaced by a blank image.
  static const bool SAFETY = true;

  // enhance_prompt: Enhance prompts for better results; default: yes, options: yes/no;

  static const List<String> ADULT_WORDS = [
    'sex',
    'nude',
    'porn',
    'erotic',
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

  /* Subscription Url's */
  static const String cancelSubscriptionUrl =
      'https://play.google.com/store/account/subscriptions?pli=1';
  static const String privacyPolicyUrl =
      'https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldo=0&ldt=privacynotice&ldl=en_GB';
  static const String termsAndConditionsUrl =
      'https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldl=en_GB&ldo=0&ldt=buyertos';

  // Shared Key
  static const String THEME = 'theme';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String ON_BOARDING_SKIP = 'on_boarding_skip';
  static const String API_LANGUAGE = 'api_language';
  static const String NEGATIVE_PROMPT = 'negative_prompt';
  static const String GUIDANCE_SCALE = 'guidance_scale';
  static const String IMAGE_QUALITY = 'image_quality';
  static const String ASPECT_RATIO = 'aspect_ratioo';
  static const String SELECTED_STYLE = 'selected_style';
  static const String SELECTED_MODEL = 'selected_model1';
  static const String STEPS = 'steps';
  static const String ENHANCE_PROMPT = 'enhance_prompt';
  static const String FAVORITE_MODELS = 'favorite_models';
  static const String OPEN_COUNT = 'open_count';

  // More Apps
  static List<MoreApps> moreApps = [
    MoreApps(
      name: 'Voice Change: AI Voice Effect',
      image: 'assets/images/app_1.png',
      url:
          'https://play.google.com/store/apps/details?id=com.sound.voiceeffects.voicechanger&hl=en&gl=US',
      descriptiion: 'Generate AI voices & try different AI voice effects',
    ),
    MoreApps(
      name: 'AI Chat - Chatbot Ask Anything',
      image: 'assets/images/app_2.png',
      url: 'https://play.google.com/store/apps/details?id=com.dcodax.chatbot',
      descriptiion: 'Generate AI voices & try different AI voice effects',
    ),
    MoreApps(
      name: 'AI Chat - Virtual Girlfriend',
      image: 'assets/images/app_3.png',
      url:
          'https://play.google.com/store/apps/details?id=com.AIchat.AIgirlchat.AIanimechat.AIgirlfriendchatbot',
      descriptiion: 'Allows you to chat with a virtual girlfriend.',
    ),
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

  // ad's id
  static const String SPLASH_INTERSTITIAL_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/6792861832';

  static const String SETTING_INTERSTITIAL_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/9746328236';

  static const String BACK_INTERSTITIAL_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/9035881798';

  static const String ONGENERATE_INTERSTITIAL_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/2723786510';

  static const String ONGENERATE_VIDEO_INTERSTITIAL_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/2206746967';

  static const String APP_OPEN_ID = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5244304915957936/3863439336';
}

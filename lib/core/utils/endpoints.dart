// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class Endpoints {
  // Base URL
  static const String DOMAIN =
      // "http://192.168.18.40:8000";
      'https://pixartai.dcodax.net';
  static const String baseUrl = '$DOMAIN/api/';
  static const String token = 'w3lc0m3';

  // API Endpoints
  static const String generateImage = 'images/generate-image';
  static const String removeBackground = 'images/remove-background';
  static const String upscaleImage = 'images/upscale-image';

  static const String MODELS_URL = 'ai-models';
  static const String INSIPIRATIONS_URL = 'inspirations';
  static const String FEEDBACK_URL = 'feedback-save';
  static const String CONFIG_URL = 'config';
  static const String GET_ADS = 'ad-list';
  static const String TOGETHER_API_KEY = "api-key?token=w3lc0m3";
}

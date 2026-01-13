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
  static const String tools = 'tool-list';

  // auth
  static const String signup = 'signup';
  static const String login = 'login';

  static const String models = 'gen-model-list';
  static const String inspirations = 'inspirations';
  static const String feedback = 'feedback-save';
  static const String config = 'config';
  static const String ads = 'ad-list';
}

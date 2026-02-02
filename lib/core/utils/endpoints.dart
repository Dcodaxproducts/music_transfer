// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class Endpoints {
  // Base URL
  static const String DOMAIN =
      // "http://192.168.18.40:8000";
      'https://pixartai.dcodax.net';
  static const String baseUrl = '$DOMAIN/api/';

  // API Endpoints
  static const String generateImage = 'images/generate-image';
  static const String tools = 'tool-category-list';

  // auth
  static const String register = 'register';
  static const String login = 'login';
  static const String socialLogin = 'social-login';
  static const String logout = 'logout';
  static const String verifyEmail = 'verify-email';
  static const String resendOtp = 'resend-otp';
  static const String forgetPassword = 'forgot-password';
  static const String changePassword = 'change-password';

  // profile
  static const String profile = 'profile';
  static const String updateProfile = 'update-profile';

  static const String models = 'gen-model-list';
  static const String inspirations = 'inspirations';
  static const String feedback = 'feedback-save';
  static const String config = 'config';
  static const String ads = 'ad-list';
}

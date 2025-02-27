import '../enum/ad_position.dart';

extension AdPositionExtension on AdPosition {
  static AdPosition fromString(String value) {
    switch (value) {
      case 'app_open':
        return AdPosition.appOpen;
      case 'model_screen':
        return AdPosition.modelScreen;
      case 'prompt_setting_screen':
        return AdPosition.promptSettingScreen;
      case 'result_screen':
        return AdPosition.resultScreen;
      case 'history_screen':
        return AdPosition.historyScreen;
      case 'inspiration_screen':
        return AdPosition.inspirationScreen;
      case 'on_generate_video':
        return AdPosition.onGenerateVideo;
      case 'on_generate_interstitial':
        return AdPosition.onGenerateInterstitial;
      case 'language_screen':
        return AdPosition.languageScreen;
      default:
        return AdPosition.appOpen;
    }
  }
}

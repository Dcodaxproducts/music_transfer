enum AdPosition {
  appOpen('app_open'),
  modelScreen('model_screen'),
  promptSettingScreen('prompt_setting_screen'),
  resultScreen('result_screen'),
  historyScreen('history_screen'),
  inspirationScreen('inspiration_screen'),
  onGenerateVideo('on_generate_video'),
  appsScreen('apps_screen'),
  languageScreen('language_screen');

  final String value;
  const AdPosition(this.value);

  static AdPosition fromString(String value) {
    return AdPosition.values.firstWhere((e) => e.value == value, orElse: () => AdPosition.onGenerateVideo);
  }
}

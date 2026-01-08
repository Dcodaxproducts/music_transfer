class LanguageModel {
  String languageName;
  String languageCode;
  String countryCode;

  LanguageModel({required this.languageName, required this.countryCode, required this.languageCode});
}

// Language
List<LanguageModel> appLanguages = [
  LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
  LanguageModel(languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  LanguageModel(languageName: 'Chinese', countryCode: 'CN', languageCode: 'zh'),
  LanguageModel(languageName: 'French', countryCode: 'FR', languageCode: 'fr'),
  LanguageModel(languageName: 'German', countryCode: 'DE', languageCode: 'de'),
  LanguageModel(languageName: 'Indonesian', countryCode: 'ID', languageCode: 'id'),
  LanguageModel(languageName: 'Italian', countryCode: 'IT', languageCode: 'it'),
  LanguageModel(languageName: 'Japanese', countryCode: 'JP', languageCode: 'ja'),
  LanguageModel(languageName: 'Korean', countryCode: 'KR', languageCode: 'ko'),
  LanguageModel(languageName: 'Malay', countryCode: 'MY', languageCode: 'ms'),
  LanguageModel(languageName: 'Portaguese', countryCode: 'PT', languageCode: 'pt'),
  LanguageModel(languageName: 'Russian', countryCode: 'RU', languageCode: 'ru'),
  LanguageModel(languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  LanguageModel(languageName: 'Swedish', countryCode: 'SE', languageCode: 'sv'),
  LanguageModel(languageName: 'Thai', countryCode: 'TH', languageCode: 'th'),
  LanguageModel(languageName: 'Turkish', countryCode: 'TR', languageCode: 'tr'),
  LanguageModel(languageName: 'Romanian', countryCode: 'RO', languageCode: 'ro'),
  LanguageModel(languageName: 'Persian', countryCode: 'IR', languageCode: 'fa'),
  LanguageModel(languageName: 'Vietnamese', countryCode: 'VN', languageCode: 'vi'),
];

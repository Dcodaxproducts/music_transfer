import 'package:pixart_app/features/language/data/model/language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/service/localization_service.dart';

class LocalizationController extends GetxController implements GetxService {
  final LocalizationService service;
  LocalizationController({required this.service}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(appLanguages[0].languageCode, appLanguages[0].countryCode);
  Locale get locale => _locale;
  List<LanguageModel> _languages = [];
  LanguageModel _selectedLanguage = appLanguages[0];

  List<LanguageModel> get languages => _languages;
  LanguageModel get selectedLanguage => _selectedLanguage;

  void setLanguage(LanguageModel value) {
    Get.updateLocale(Locale(value.languageCode, value.countryCode));
    _locale = Locale(value.languageCode, value.countryCode);
    _selectedLanguage = value;
    service.saveLanguage(value);
    update();
  }

  void loadCurrentLanguage() async {
    LanguageModel language = service.loadCurrentLanguage();
    setLanguage(language);
    _selectedLanguage = language;
    _languages = List.from(appLanguages);
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = List.from(appLanguages);
    } else {
      _languages = appLanguages
          .where((language) => language.languageName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  static LocalizationController get find => Get.find();
}

// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:matrix_ai/features/language/data/model/language.dart';
import 'package:matrix_ai/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/service/localization_service_interface.dart';

class LocalizationController extends GetxController implements GetxService {
  final LocalizationServiceInterface localizationService;
  LocalizationController({required this.localizationService}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(
    AppConstants.languages[0].languageCode,
    AppConstants.languages[0].countryCode,
  );
  bool _isLtr = true;
  List<LanguageModel> _languages = [];
  int _selectedIndex = 0;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;
  int get selectedIndex => _selectedIndex;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = _locale.languageCode != 'ar' && _locale.languageCode != 'fa';
    saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() async {
    Locale locale = localizationService.loadCurrentLanguage();
    setLanguage(locale);
    _languages = List.from(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    await localizationService.saveLanguage(locale);
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = List.from(AppConstants.languages);
    } else {
      _selectedIndex = -1;
      _languages = AppConstants.languages
          .where((language) => language.languageName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  static LocalizationController get to => Get.find();
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization_service_interface.dart';
import 'package:matrix_ai/utils/app_constants.dart';

class LocalizationService implements LocalizationServiceInterface {
  final SharedPreferences sharedPreferences;

  LocalizationService({required this.sharedPreferences});

  @override
  Locale loadCurrentLanguage() {
    return Locale(
      sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ??
          AppConstants.languages[0].languageCode,
      sharedPreferences.getString(AppConstants.COUNTRY_CODE) ??
          AppConstants.languages[0].countryCode,
    );
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    await sharedPreferences.setString(
        AppConstants.LANGUAGE_CODE, locale.languageCode);
    await sharedPreferences.setString(
        AppConstants.COUNTRY_CODE, locale.countryCode!);
  }

  @override
  List<Locale> get availableLanguages {
    return AppConstants.languages
        .map((lang) => Locale(lang.languageCode, lang.countryCode))
        .toList();
  }
}

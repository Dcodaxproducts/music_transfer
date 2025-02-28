import 'package:matrix_ai/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_repo_interface.dart';

class LocalizationRepo implements LocalizationRepoInterface {
  final SharedPreferences prefs;

  LocalizationRepo({required this.prefs});

  @override
  List<Locale> get availableLanguages {
    return AppConstants.languages.map((lang) => Locale(lang.languageCode, lang.countryCode)).toList();
  }

  @override
  Locale loadCurrentLanguage() {
    return Locale(
      prefs.getString(AppConstants.LANGUAGE_CODE) ?? AppConstants.languages[0].languageCode,
      prefs.getString(AppConstants.COUNTRY_CODE) ?? AppConstants.languages[0].countryCode,
    );
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    await prefs.setString(AppConstants.LANGUAGE_CODE, locale.languageCode);
    await prefs.setString(AppConstants.COUNTRY_CODE, locale.countryCode!);
  }
}

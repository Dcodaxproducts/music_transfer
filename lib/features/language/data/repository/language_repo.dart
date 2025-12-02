import 'package:pixart_app/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_repo_interface.dart';

class LocalizationRepo implements LocalizationRepoInterface {
  final SharedPreferences prefs;

  LocalizationRepo({required this.prefs});

  @override
  List<Locale> get availableLanguages {
    return appLanguages.map((lang) => Locale(lang.languageCode, lang.countryCode)).toList();
  }

  @override
  Locale loadCurrentLanguage() {
    return Locale(
      prefs.getString(SharedKeys.LANGUAGE_CODE) ?? appLanguages[0].languageCode,
      prefs.getString(SharedKeys.COUNTRY_CODE) ?? appLanguages[0].countryCode,
    );
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    await prefs.setString(SharedKeys.LANGUAGE_CODE, locale.languageCode);
    await prefs.setString(SharedKeys.COUNTRY_CODE, locale.countryCode!);
  }
}

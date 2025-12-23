import 'package:pixart_app/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_repo_interface.dart';

class ThemeRepo implements ThemeRepoInterface {
  final SharedPreferences prefs;
  ThemeRepo({required this.prefs});

  @override
  String? loadCurrentTheme() {
    return prefs.getString(SharedKeys.theme);
  }

  @override
  Future<bool> setTheme(String themeMode) async {
    return await prefs.setString(SharedKeys.theme, themeMode);
  }
}

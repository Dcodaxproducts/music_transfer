import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/app_constants.dart';
import 'theme_service_interface.dart';

class ThemeService implements ThemeServiceInterface {
  final SharedPreferences sharedPreferences;
  ThemeService({required this.sharedPreferences});

  @override
  Future<ThemeMode> loadCurrentTheme() async {
    String? data;
    try {
      data = sharedPreferences.getString(AppConstants.THEME);
    } catch (e) {
      data = 'system';
    }
    if (data == null || data == 'system') {
      return ThemeMode.system;
    } else if (data == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    String mode = 'system';
    switch (themeMode) {
      case ThemeMode.light:
        mode = 'light';
        break;
      case ThemeMode.dark:
        mode = 'dark';
        break;
      default:
        mode = 'system';
    }
    await sharedPreferences.setString(AppConstants.THEME, mode);
  }
}

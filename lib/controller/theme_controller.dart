import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  ThemeMode _themeMode = ThemeMode.light;
  Color? _lightColor;
  Color? _darkColor;

  ThemeMode get themeMode => _themeMode;
  Color? get darkColor => _darkColor;
  Color? get lightColor => _lightColor;

  void _loadCurrentTheme() async {
    String? data = sharedPreferences.getString(AppConstants.THEME);
    if (data == null || data == 'system') {
      _themeMode = ThemeMode.system;
    } else if (data == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    update();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
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
    sharedPreferences.setString(AppConstants.THEME, mode);
    update();
  }

  static ThemeController get find => Get.find();
}

bool get isDark => Get.isDarkMode;

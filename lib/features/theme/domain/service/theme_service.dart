import 'package:flutter/material.dart';
import 'package:pixart_app/features/theme/data/repository/theme_repo_interface.dart';
import 'theme_service_interface.dart';

class ThemeService implements ThemeServiceInterface {
  final ThemeRepoInterface themeRepo;
  ThemeService({required this.themeRepo});

  @override
  Future<ThemeMode> loadCurrentTheme() async {
    String? data;
    try {
      data = themeRepo.loadCurrentTheme();
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
    await themeRepo.setTheme(mode);
  }
}

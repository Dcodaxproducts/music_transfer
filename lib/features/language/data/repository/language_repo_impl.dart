import 'dart:convert';

import 'package:pixart_app/imports.dart';
import 'language_repo.dart';

class LocalizationRepoImpl implements LocalizationRepo {
  final SharedPreferences prefs;
  LocalizationRepoImpl({required this.prefs});

  @override
  String? loadCurrentLanguage() {
    return prefs.getString(SharedKeys.language);
  }

  @override
  Future<bool> saveLanguage(Map<String, dynamic> args) async {
    return await prefs.setString(SharedKeys.language, jsonEncode(args));
  }
}

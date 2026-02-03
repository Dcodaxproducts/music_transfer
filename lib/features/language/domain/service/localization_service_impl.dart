import 'dart:convert';
import 'package:pixart_app/imports.dart';
import '../../data/repository/language_repo.dart';
import 'localization_service.dart';

class LocalizationServiceImpl implements LocalizationService {
  final LocalizationRepo repo;
  LocalizationServiceImpl({required this.repo});

  @override
  LanguageModel loadCurrentLanguage() {
    String? langString = repo.loadCurrentLanguage();
    if (langString != null) {
      Map<String, dynamic> langMap = jsonDecode(langString);
      LanguageModel language = LanguageModel.fromJson(langMap);
      return language;
    } else {
      return appLanguages.first;
    }
  }

  @override
  Future<bool> saveLanguage(LanguageModel language) async {
    return await repo.saveLanguage(language.toJson());
  }
}

import '../../../../imports.dart';

abstract class LocalizationService {
  LanguageModel loadCurrentLanguage();
  Future<bool> saveLanguage(LanguageModel language);
}

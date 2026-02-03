abstract class LocalizationRepo {
  String? loadCurrentLanguage();
  Future<bool> saveLanguage(Map<String, dynamic> args);
}

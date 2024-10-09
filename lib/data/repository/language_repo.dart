import 'package:matrix_ai/data/model/language.dart';
import 'package:matrix_ai/utils/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages() {
    return AppConstants.languages;
  }
}

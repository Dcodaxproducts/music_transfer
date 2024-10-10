import 'package:matrix_ai/data/model/language.dart';
import 'package:matrix_ai/utils/app_constants.dart';

import 'language_repo_interface.dart';

class LanguageRepo implements LanguageRepoInterface {
  @override
  List<LanguageModel> getAllLanguages() {
    return AppConstants.languages;
  }
}

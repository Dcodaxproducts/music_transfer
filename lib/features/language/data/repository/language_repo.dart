import 'package:matrix_ai/features/language/data/model/language.dart';
import 'package:matrix_ai/core/utils/app_constants.dart';

import 'language_repo_interface.dart';

class LanguageRepo implements LanguageRepoInterface {
  @override
  List<LanguageModel> getAllLanguages() {
    return AppConstants.languages;
  }
}

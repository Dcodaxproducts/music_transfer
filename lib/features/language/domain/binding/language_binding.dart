import 'package:pixart_app/imports.dart';
import '../../data/repository/language_repo_impl.dart';
import '../../data/repository/language_repo.dart';
import '../service/localization_service_impl.dart';
import '../service/localization_service.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    LocalizationRepo localizationRepoInterface = LocalizationRepoImpl(prefs: Get.find());
    Get.lazyPut(() => localizationRepoInterface, fenix: true);
    // service
    LocalizationService localizationServiceInterface = LocalizationServiceImpl(repo: Get.find());
    Get.lazyPut(() => localizationServiceInterface, fenix: true);
    // controller
    Get.lazyPut(() => LocalizationController(service: Get.find()));
  }
}

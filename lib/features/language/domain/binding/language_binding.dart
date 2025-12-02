import 'package:pixart_app/imports.dart';
import '../../data/repository/language_repo.dart';
import '../../data/repository/language_repo_interface.dart';
import '../service/localization_service.dart';
import '../service/localization_service_interface.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    LocalizationRepoInterface localizationRepoInterface = LocalizationRepo(prefs: Get.find());
    Get.lazyPut(() => localizationRepoInterface, fenix: true);
    // service
    LocalizationServiceInterface localizationServiceInterface = LocalizationService(
      localizationRepo: Get.find(),
    );
    Get.lazyPut(() => localizationServiceInterface, fenix: true);
    // controller
    Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  }
}

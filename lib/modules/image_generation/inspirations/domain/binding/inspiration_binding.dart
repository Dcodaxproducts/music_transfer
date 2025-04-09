import 'package:get/get.dart';
import '../../data/repository/inspiration_repo.dart';
import '../../data/repository/inspiration_repo_interface.dart';
import '../../presentation/controller/inspiration_controller.dart';
import '../service/inspiration_service.dart';
import '../service/inspiration_service_interface.dart';

class InspirationBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    InspirationRepoInterface inspirationRepoInterface =
        InspirationRepo(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => inspirationRepoInterface, fenix: true);

    // service
    InspirationServiceInterface inspirationServiceInterface = InspirationService(inspirationRepo: Get.find());
    Get.lazyPut(() => inspirationServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => InspirationController(inspirationService: Get.find()));
  }
}

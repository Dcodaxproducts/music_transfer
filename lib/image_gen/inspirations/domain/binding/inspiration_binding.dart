import 'package:get/get.dart';
import '../../data/repository/inspiration_repo_impl.dart';
import '../../data/repository/inspiration_repo.dart';
import '../../presentation/controller/inspiration_controller.dart';
import '../service/inspiration_service_impl.dart';
import '../service/inspiration_service.dart';

class InspirationBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    InspirationRepo inspirationRepo = InspirationRepoImpl(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => inspirationRepo);

    // service
    InspirationService inspirationServiceInterface = InspirationServiceImpl(inspirationRepo: Get.find());
    Get.lazyPut(() => inspirationServiceInterface);

    // controller
    Get.lazyPut(() => InspirationController(service: Get.find()));
  }
}

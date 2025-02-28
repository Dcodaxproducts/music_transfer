import 'package:get/get.dart';
import '../../data/repository/background_remover_repo.dart';
import '../../data/repository/background_remover_repo_interface.dart';
import '../../presentation/controller/background_remover_controller.dart';
import '../service/background_remover_service.dart';
import '../service/background_remover_service_interface.dart';

class BackgroundRemoverBindings extends Bindings {
  @override
  void dependencies() {
    // repo
    BackgroundRemoverRepoInterface backgroundRemoverRepoInterface =
        BackgroundRemoverRepo(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => backgroundRemoverRepoInterface, fenix: true);

    // service
    BackgroundRemoverServiceInterface backgroundRemoverServiceInterface =
        BackgroundRemoverService(backgroundRemoverRepo: Get.find());
    Get.lazyPut(() => backgroundRemoverServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => BackgroundRemoverController(backgroundRemoverService: Get.find()));
  }
}

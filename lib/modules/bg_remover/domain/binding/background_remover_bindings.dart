import 'package:get/get.dart';
import '../../data/repository/bg_remover_repo_impl.dart';
import '../../data/repository/bg_remover_repo.dart';
import '../../presentation/controller/background_remover_controller.dart';
import '../service/bg_remover_service_impl.dart';
import '../service/bg_remover_service.dart';

class BackgroundRemoverBindings extends Bindings {
  @override
  void dependencies() {
    // repo
    BgRemoverRepo backgroundRemoverRepoInterface = BgRemoverRepoImpl(
      apiClient: Get.find(),
      prefs: Get.find(),
    );
    Get.lazyPut(() => backgroundRemoverRepoInterface, fenix: true);

    // service
    BgRemoverService backgroundRemoverServiceInterface = BgRemoverServiceImpl(
      backgroundRemoverRepo: Get.find(),
    );
    Get.lazyPut(() => backgroundRemoverServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => BgRemoverController(service: Get.find()));
  }
}

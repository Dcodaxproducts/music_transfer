import 'package:get/get.dart';
import 'package:pixart_app/modules/image_upscale/data/repository/image_upscale_repo.dart';
import 'package:pixart_app/modules/image_upscale/domain/service/image_upscale_service.dart';
import '../../data/repository/image_upscale_repo_impl.dart';
import '../../presentation/controller/image_upscale_controller.dart';
import '../service/image_upscale_service_impl.dart';

class UpscaleBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ImageUpscaleRepo imageUpscaleRepoInterface = ImageUpscaleRepoImpl(
      apiClient: Get.find(),
      prefs: Get.find(),
    );
    Get.lazyPut(() => imageUpscaleRepoInterface, fenix: true);

    // service
    ImageUpscaleService imageUpscaleServiceInterface = ImageUpscaleServiceImpl(
      repo: Get.find(),
    );
    Get.lazyPut(() => imageUpscaleServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ImageUpscaleController(service: Get.find()), fenix: true);
  }
}

import 'package:get/get.dart';
import 'package:pixart_app/modules/upscale/image_upscale/data/repository/image_upscale_repo_interface.dart';
import 'package:pixart_app/modules/upscale/image_upscale/domain/service/image_upscale_service_interface.dart';
import '../../data/repository/image_upscale_repo.dart';
import '../../presentation/controller/image_upscale_controller.dart';
import '../../presentation/controller/upscale_image_queue_controller.dart';
import '../service/image_upscale_service.dart';

class UpscaleBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ImageUpscaleRepoInterface imageUpscaleRepoInterface = ImageUpscaleRepo(
      apiClient: Get.find(),
      prefs: Get.find(),
    );
    Get.lazyPut(() => imageUpscaleRepoInterface, fenix: true);

    // service
    ImageUpscaleServiceInterface imageUpscaleServiceInterface = ImageUpscaleService(
      imageUpscaleRepo: Get.find(),
    );
    Get.lazyPut(() => imageUpscaleServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ImageUpscaleController(imageUpscaleService: Get.find()), fenix: true);
    Get.lazyPut(() => UpscaleImageQueueController(), fenix: true);
  }
}

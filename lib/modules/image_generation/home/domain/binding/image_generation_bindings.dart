import 'package:get/get.dart';
import 'package:matrix_ai/modules/image_generation/home/domain/service/image_generation_service_interface.dart';
import '../../data/repository/image_generation_repo.dart';
import '../../data/repository/image_generation_repo_interface.dart';
import '../../presentation/controller/image_generation_controller.dart';
import '../service/image_generation_service.dart';

class ImageGenerationBindings extends Bindings {
  @override
  void dependencies() {
    // repo
    ImageGenerationRepoInterface imageGenerationRepoInterface =
        ImageGenerationRepo(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => imageGenerationRepoInterface, fenix: true);

    // service
    ImageGenerationServiceInterface imageGenerationServiceInterface =
        ImageGenerationService(imageGenerationRepo: Get.find());
    Get.lazyPut(() => imageGenerationServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ImageGenerationController(imageGenerationServiceInterface: Get.find()));
  }
}

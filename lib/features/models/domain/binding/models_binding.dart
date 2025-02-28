import 'package:matrix_ai/imports.dart';
import '../../../home/data/repository/image_generation_repo.dart';
import '../../../home/data/repository/image_generation_repo_interface.dart';
import '../../../home/domain/service/image_generation_service.dart';
import '../../../home/domain/service/image_generation_service_interface.dart';
import '../../../home/presentation/controller/image_generation_controller.dart';

class ModelsBinding extends Bindings {
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

import 'package:get/get.dart';
import 'package:pixart_app/image_gen/home/domain/service/image_gen_service.dart';
import '../../data/repository/image_gen_repo_impl.dart';
import '../../data/repository/image_gen_repo.dart';
import '../../presentation/controller/image_generation_controller.dart';
import '../service/image_gen_service_impl.dart';

class ImageGenerationBindings extends Bindings {
  @override
  void dependencies() {
    // repo
    ImageGenRepo imageGenerationRepoInterface = ImageGenRepoImpl(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => imageGenerationRepoInterface, fenix: true);

    // service
    ImageGenService imageGenerationServiceInterface = ImageGenerationServiceImpl(repo: Get.find());
    Get.lazyPut(() => imageGenerationServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ImageGenController(service: Get.find()));
  }
}

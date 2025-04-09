import 'package:get/get.dart';
import '../../data/repository/generation_repo.dart';
import '../../data/repository/generation_repo_interface.dart';
import '../../presentation/controller/generation_controller.dart';
import '../service/generation_service.dart';
import '../service/generation_service_interface.dart';

class GenerationBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    GenerationRepoInterface generationRepoInterface = GenerationRepo(prefs: Get.find());
    Get.lazyPut(() => generationRepoInterface, fenix: true);

    // service
    GenerationServiceInterface generationServiceInterface =
        GenerationService(generationRepoInterface: Get.find());
    Get.lazyPut(() => generationServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => GenerationController(generationServiceInterface: Get.find()));
  }
}

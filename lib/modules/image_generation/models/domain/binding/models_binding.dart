import 'package:matrix_ai/modules/image_generation/models/data/repository/models_repo.dart';
import 'package:matrix_ai/modules/image_generation/models/domain/service/model_service_interface.dart';
import 'package:matrix_ai/modules/image_generation/models/presentation/controller/models_controller.dart';
import 'package:matrix_ai/imports.dart';
import '../../data/repository/models_repo_interface.dart';
import '../service/model_service.dart';

class ModelsBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ModelsRepoInterface modelsRepoInterface = ModelsRepo(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => modelsRepoInterface, fenix: true);

    // service
    ModelsServiceInterface modelsServiceInterface = ModelsService(modelsRepo: Get.find());
    Get.lazyPut(() => modelsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ModelsController(modelsService: Get.find()));
  }
}

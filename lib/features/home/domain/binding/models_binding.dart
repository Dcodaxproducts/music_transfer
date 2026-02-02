import 'package:pixart_app/features/home/data/repository/models_repo_impl.dart';
import 'package:pixart_app/features/home/domain/service/model_service.dart';
import 'package:pixart_app/features/home/presentation/controller/models_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../data/repository/models_repo.dart';
import '../service/model_service_impl.dart';

class ModelsBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ModelsRepo modelsRepoInterface = ModelsRepoImpl(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => modelsRepoInterface, fenix: true);

    // service
    ModelsService modelsServiceInterface = ModelsServiceImpl(modelsRepo: Get.find());
    Get.lazyPut(() => modelsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ModelsController(modelsService: Get.find()));
  }
}

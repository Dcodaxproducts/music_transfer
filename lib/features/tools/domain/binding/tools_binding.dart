import 'package:get/get.dart';
import 'package:pixart_app/features/tools/data/repository/tools_repo_interface.dart';
import 'package:pixart_app/features/tools/domain/service/tools_service_interface.dart';
import '../../data/repository/tools_repo.dart';
import '../../presentation/controller/tools_controller.dart';
import '../service/tools_service.dart';

class ToolsBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ToolsRepoInterface toolsRepoInterface = ToolsRepo(apiClient: Get.find());
    Get.lazyPut(() => toolsRepoInterface, fenix: true);

    // service
    ToolsServiceInterface toolsServiceInterface = ToolsService(
      toolsRepo: Get.find(),
    );
    Get.lazyPut(() => toolsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ToolsController(toolsService: Get.find()));
  }
}

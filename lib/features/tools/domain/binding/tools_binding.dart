import 'package:get/get.dart';
import 'package:pixart_app/features/tools/data/repository/tools_repo.dart';
import 'package:pixart_app/features/tools/domain/service/tools_service.dart';
import '../../data/repository/tools_repo_impl.dart';
import '../../presentation/controller/tools_controller.dart';
import '../service/tools_service_impl.dart';

class ToolsBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ToolsRepo toolsRepoInterface = ToolsRepoImpl(client: Get.find());
    Get.lazyPut(() => toolsRepoInterface, fenix: true);

    // service
    ToolsService toolsServiceInterface = ToolsServiceImpl(toolsRepo: Get.find());
    Get.lazyPut(() => toolsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ToolsController(service: Get.find()));
  }
}

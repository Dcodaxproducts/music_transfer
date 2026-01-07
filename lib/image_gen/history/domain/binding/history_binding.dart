import 'package:get/get.dart';
import 'package:pixart_app/image_gen/history/data/repository/history_repo.dart';
import '../../data/repository/history_repo_impl.dart';
import '../../presentation/controller/history_controller.dart';
import '../service/history_service_impl.dart';
import '../service/history_service.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    HistoryRepo historyRepoInterface = HistoryRepoImpl(
      apiClient: Get.find(),
      prefs: Get.find(),
    );
    Get.lazyPut(() => historyRepoInterface, fenix: true);

    // service
    HistoryService adsServiceInterface = HistoryServiceImpl(repo: Get.find());
    Get.lazyPut(() => adsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(
      () => HistoryController(historyService: Get.find()),
      fenix: true,
    );
  }
}

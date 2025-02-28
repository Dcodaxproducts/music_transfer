import 'package:get/get.dart';
import 'package:matrix_ai/features/history/data/repository/history_repo_interface.dart';

import '../../../ads/domain/service/ads_service.dart';
import '../../../ads/domain/service/ads_service_interface.dart';
import '../../data/repository/history_repo.dart';
import '../../presentation/controller/history_controller.dart';
import '../../presentation/controller/queue_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    HistoryRepoInteraface historyRepoInterface = HistoryRepo(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => historyRepoInterface, fenix: true);

    // service
    AdsServiceInterface adsServiceInterface = AdsService(adRepo: Get.find());
    Get.lazyPut(() => adsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => HistoryController(historyService: Get.find()), fenix: true);
    Get.lazyPut(() => QueueController(), fenix: true);
  }
}

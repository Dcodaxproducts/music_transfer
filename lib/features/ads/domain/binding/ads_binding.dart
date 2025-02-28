import 'package:get/get.dart';
import '../../data/repository/ad_repo.dart';
import '../../data/repository/ad_repo_interface.dart';
import '../../presentation/controller/ads_controller.dart';
import '../service/ads_service.dart';
import '../service/ads_service_interface.dart';

class AdsBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    AdRepoInterface adRepoInterface = AdRepo(apiClient: Get.find());
    Get.lazyPut(() => adRepoInterface, fenix: true);

    // service
    AdsServiceInterface adsServiceInterface = AdsService(adRepo: Get.find());
    Get.lazyPut(() => adsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => AdsController(adsService: Get.find()));
  }
}

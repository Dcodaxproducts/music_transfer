import 'package:get/get.dart';
import '../../data/repository/ad_repo_impl.dart';
import '../../data/repository/ad_repo.dart';
import '../../presentation/controller/ads_controller.dart';
import '../service/ads_service.dart';
import '../service/ads_service_interface.dart';

class AdsBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    AdRepo adRepoInterface = AdRepoImpl(apiClient: Get.find());
    Get.lazyPut(() => adRepoInterface, fenix: true);

    // service
    AdsServiceInterface adsServiceInterface = AdsService(adRepo: Get.find());
    Get.lazyPut(() => adsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => AdsController(adsService: Get.find()));
  }
}

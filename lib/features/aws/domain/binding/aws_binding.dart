import 'package:get/get.dart';
import '../../../ads/domain/service/ads_service.dart';
import '../../../ads/domain/service/ads_service_interface.dart';
import '../../../ads/presentation/controller/ads_controller.dart';

class AwsBinding extends Bindings {
  @override
  void dependencies() {
    // service
    AdsServiceInterface adsServiceInterface = AdsService(adRepo: Get.find());
    Get.lazyPut(() => adsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => AdsController(adsService: Get.find()));
  }
}

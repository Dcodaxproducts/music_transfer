import 'package:get/get.dart';
import 'package:pixart_app/features/splash/data/repository/splash_repo.dart';
import 'package:pixart_app/features/splash/domain/service/splash_service.dart';
import '../../data/repository/splash_repo_impl.dart';
import '../../presentation/controller/splash_controller.dart';
import '../service/splash_service_impl.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    SettingsRepo splashRepo = SettingsRepoImpl(prefs: Get.find());
    Get.lazyPut(() => splashRepo, fenix: true);

    // services
    SplashService splashService = SplashServiceImpl(settingsRepo: Get.find());
    Get.lazyPut(() => splashService, fenix: true);

    // controller
    Get.lazyPut(() => SplashController(service: Get.find()));
  }
}

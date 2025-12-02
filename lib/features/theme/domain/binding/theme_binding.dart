import 'package:get/get.dart';
import 'package:pixart_app/features/theme/data/repository/theme_repo_interface.dart';
import 'package:pixart_app/features/theme/domain/service/theme_service_interface.dart';
import '../../data/repository/theme_repo.dart';
import '../../presentation/controller/theme_controller.dart';
import '../service/theme_service.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ThemeRepoInterface themeRepoInterface = ThemeRepo(prefs: Get.find());
    Get.lazyPut(() => themeRepoInterface, fenix: true);

    // service
    ThemeServiceInterface themeServiceInterface = ThemeService(themeRepo: Get.find());
    Get.lazyPut(() => themeServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ThemeController(themeService: Get.find()));
  }
}

import 'package:get/get.dart';
import 'package:matrix_ai/features/prompt_setting/data/repository/settings_repo_interface.dart';
import 'package:matrix_ai/features/prompt_setting/domain/service/setting_service_interface.dart';
import '../../data/repository/settings_repo.dart';
import '../../presentation/controller/settings_controller.dart';
import '../service/setting_service.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    SettingsRepoInterface settingsRepoInterface = SettingsRepo(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => settingsRepoInterface, fenix: true);

    // service
    SettingsServiceInterface settingsServiceInterface = SettingsService(settingsRepo: Get.find());
    Get.lazyPut(() => settingsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => SettingsController(settingsService: Get.find()));
  }
}

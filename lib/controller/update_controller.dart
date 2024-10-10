import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:matrix_ai/data/service/update_service_interface.dart';

class UpdateController extends GetxController {
  final UpdateServiceInterface updateService;
  UpdateController({required this.updateService});

  static UpdateController get find => Get.find<UpdateController>();

  // AppUpdateInfo state
  AppUpdateInfo? updateInfo;

  // Check for updates and update the state
  Future<void> checkForUpdate() async {
    updateInfo = await updateService.checkForUpdate();
    if (updateInfo != null) {
      await updateService.performImmediateUpdate(updateInfo!);
    }
    update();
  }

  // Download flexible update
  Future<void> downloadFlexibleUpdate() async {
    await updateService.startFlexibleUpdate(updateInfo);
    update();
  }
}

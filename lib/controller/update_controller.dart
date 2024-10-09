import 'package:matrix_ai/common/snackbar.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateController extends GetxController {
  static UpdateController get find => Get.put(UpdateController());
  AppUpdateInfo? updateInfo;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      updateInfo = info;
      performImmediateUpdate(info);
    }).catchError((e) {
      showSnack(e.toString());
    });
    update();
  }

  Future<void> performImmediateUpdate(AppUpdateInfo info) async {
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate()
          .then((value) => showSnack('App Updated!'))
          .catchError((e) {
        showSnack(e.toString());
      });
    }
  }

  Future<void> downloadFlexibleUpdate() async {
    if (updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.startFlexibleUpdate()
          .then((value) => completeFlexibleUpdate())
          .catchError((e) {
        showSnack(e.toString());
      });
    }
  }

  Future<void> completeFlexibleUpdate() async {
    InAppUpdate.completeFlexibleUpdate().then((_) {
      showSnack("App Updated!");
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    showToast(text, success: false);
  }
}

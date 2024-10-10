import 'package:in_app_update/in_app_update.dart';
import 'package:matrix_ai/common/snackbar.dart';

import 'update_service_interface.dart';

class UpdateService implements UpdateServiceInterface {
  // Method to check for update
  @override
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();
      return info;
    } catch (e) {
      _showSnack(e.toString());
      return null;
    }
  }

  // Perform immediate update
  @override
  Future<void> performImmediateUpdate(AppUpdateInfo info) async {
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      try {
        await InAppUpdate.performImmediateUpdate();
        _showSnack('App Updated!');
      } catch (e) {
        _showSnack(e.toString());
      }
    }
  }

  // Start flexible update
  @override
  Future<void> startFlexibleUpdate(AppUpdateInfo? updateInfo) async {
    if (updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      try {
        await InAppUpdate.startFlexibleUpdate();
        await completeFlexibleUpdate();
      } catch (e) {
        _showSnack(e.toString());
      }
    }
  }

  // Complete flexible update
  @override
  Future<void> completeFlexibleUpdate() async {
    try {
      await InAppUpdate.completeFlexibleUpdate();
      _showSnack("App Updated!");
    } catch (e) {
      _showSnack(e.toString());
    }
  }

  // Private method to show snack
  void _showSnack(String text) {
    showToast(text, success: false);
  }
}

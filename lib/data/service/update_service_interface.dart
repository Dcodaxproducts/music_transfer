import 'package:in_app_update/in_app_update.dart';

abstract class UpdateServiceInterface {
  // Method to check for update
  Future<AppUpdateInfo?> checkForUpdate();

  // Perform immediate update
  Future<void> performImmediateUpdate(AppUpdateInfo info);

  // Start flexible update
  Future<void> startFlexibleUpdate(AppUpdateInfo? updateInfo);

  // Complete flexible update
  Future<void> completeFlexibleUpdate();
}

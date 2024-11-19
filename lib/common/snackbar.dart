import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

showLoading() => SmartDialog.showLoading();

dismiss() => SmartDialog.dismiss();

showToast(String text, {bool success = false}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    success ? 'success'.tr : 'error'.tr,
    text.tr,
    backgroundColor:
        success ? Theme.of(Get.context!).cardColor : const Color(0xFF90323D),
    colorText: Colors.white,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

showLoading() => SmartDialog.showLoading();

dismiss() => SmartDialog.dismiss();

showToast(String text, {bool success = false}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    success ? 'success'.tr : 'error'.tr,
    text,
    backgroundColor: success ? primaryColor : const Color(0xFF90323D),
    colorText: Colors.white,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

Future<dynamic> showLoading() => SmartDialog.showLoading();

Future<void> dismiss() => SmartDialog.dismiss();

void showToast(String text, {bool success = false}) {
  Get.snackbar(
    success ? 'success'.tr : 'error'.tr,
    text.tr,
    backgroundColor: success ? Colors.black : const Color(0xFF90323D),
    colorText: Colors.white,
  );
}

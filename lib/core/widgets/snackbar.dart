import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

Future<dynamic> showLoading() => SmartDialog.showLoading();

Future<void> dismiss() => SmartDialog.dismiss();

void showToast(String text) {
  SmartDialog.showToast(
    text,
    alignment: Alignment.topCenter,
    displayTime: const Duration(seconds: 3),
    displayType: SmartToastType.multi,
  );
}

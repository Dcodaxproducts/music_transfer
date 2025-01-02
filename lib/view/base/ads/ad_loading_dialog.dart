import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../common/loading.dart';
import '../../../utils/style.dart';

showAdLoadingDialog() {
  SmartDialog.show(
    builder: (_) => const AdLoadingDialog(),
    backType: SmartBackType.block,
    clickMaskDismiss: false,
  );
}

class AdLoadingDialog extends StatefulWidget {
  const AdLoadingDialog({super.key});

  @override
  State<AdLoadingDialog> createState() => _AdLoadingDialogState();
}

class _AdLoadingDialogState extends State<AdLoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 100.sp),
      child: Container(
        width: 150.sp,
        padding: paddingDefault,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadiusDefault,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('loading_ad'.tr, textAlign: TextAlign.center, style: bodyLarge(context)),
            Padding(
              padding: EdgeInsets.only(top: 24.sp, bottom: 8.sp),
              child: const Loading(),
            ),
          ],
        ),
      ),
    );
  }
}

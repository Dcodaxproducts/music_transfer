import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/images.dart';
import 'package:matrix_ai/view/base/gradient_widget.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';
import '../../utils/style.dart';

Future showFreeLimitDialog({required Function() onWatchAdPressed}) =>
    Get.dialog(FreeLimitDialog(onWatchAdPressed: onWatchAdPressed));

class FreeLimitDialog extends StatelessWidget {
  final Function() onWatchAdPressed;
  const FreeLimitDialog({super.key, required this.onWatchAdPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 30.sp),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        padding: pagePadding,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close, color: primaryColor),
                onPressed: Get.back,
              ),
            ),
            GradientWidget(
              child: Image.asset(
                Images.generate,
                width: 100.sp,
                height: 100.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.sp),
            Text(
              "Free Limit Reached".tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.sp),
            Text(
              "You have reached your free limit for today. Watch an ad to generate more images or go pro to remove the limit."
                  .tr,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.sp),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryOutlineButton(
                      text: 'Watch Ad',
                      onPressed: onWatchAdPressed,
                    ),
                  ),
                  SizedBox(width: 16.sp),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Go Pro'.tr,
                      onPressed: showPremiumSheet,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

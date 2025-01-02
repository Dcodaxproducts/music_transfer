import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/view/base/common/primary_button.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/images.dart';
import 'package:matrix_ai/view/base/gradient_widget.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';
import '../../utils/style.dart';

Future showFreeLimitDialog() => Get.dialog(const FreeLimitDialog());

class FreeLimitDialog extends StatelessWidget {
  const FreeLimitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: paddingDefault,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
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
              style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: spacingDefault),
            Text(
              "You have reached your free limit for today. Watch an ad to generate more images or go pro to remove the limit."
                  .tr,
              style: bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: spacingExtraLarge),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(text: 'Go Pro'.tr, onPressed: showPremiumSheet),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

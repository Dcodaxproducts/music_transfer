import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/common/snackbar.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';

class PromptReportButton extends StatelessWidget {
  const PromptReportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.sp,
      right: 10.sp,
      child: InkWell(
        onTap: showFeedbackDialog,
        borderRadius: borderRadius,
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: borderRadius,
          ),
          child: Icon(Iconsax.flag, size: 22.sp, color: Colors.white),
        ),
      ),
    );
  }
}

void showFeedbackDialog() => Get.dialog(const FeedbackDialog());

class FeedbackDialog extends StatelessWidget {
  const FeedbackDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).shadowColor,
      child: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "${'feedback'.tr}/${'report'.tr}",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.sp),

            // Subtitle
            Text(
              "is_this_the_result_you_were_expecting".tr,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.sp),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    color: Theme.of(context).cardColor,
                    icon: Icon(
                      Iconsax.dislike,
                      color: Theme.of(context).disabledColor,
                    ),
                    text: "",
                    onPressed: showReportDialog,
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: PrimaryButton(
                    icon: Icon(
                      Iconsax.like_1,
                      color: Theme.of(context).disabledColor,
                    ),
                    color: Theme.of(context).cardColor,
                    text: "",
                    onPressed: _like,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _like() {
    showLoading();
    Future.delayed(const Duration(seconds: 1), () {
      dismiss();
      pop();
      showToast("feedback_submitted_successfully", success: true);
    });
  }
}

void showReportDialog() => Get.dialog(const ReportingDialog());

class ReportingDialog extends StatefulWidget {
  const ReportingDialog({super.key});

  @override
  State<ReportingDialog> createState() => _ReportingDialogState();
}

class _ReportingDialogState extends State<ReportingDialog> {
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).shadowColor,
      child: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${'feedback'.tr}/${'report'.tr}",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.sp),
            RadioListTile<String>(
              visualDensity: VisualDensity.compact,
              activeColor: primaryColor, // Custom active color
              title: Text(
                "result_is_not_accurate".tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              value: "not_accurate",
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              activeColor: primaryColor,
              title: Text(
                "inappropriate_content".tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              value: "inappropriate",
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
            SizedBox(height: 16.sp),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                color: Theme.of(context).cardColor,
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
                text: "submit".tr,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit() {
    if (selectedOption == null) {
      return;
    }
    showLoading();
    Future.delayed(const Duration(seconds: 1), () {
      dismiss();
      pop();
      pop();
      showToast("feedback_submitted_successfully", success: true);
    });
  }
}

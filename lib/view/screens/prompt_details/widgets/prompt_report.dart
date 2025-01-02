import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/view/base/common/primary_button.dart';
import 'package:matrix_ai/view/base/common/snackbar.dart';
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
        borderRadius: borderRadiusDefault,
        child: Container(
          padding: paddingSmall,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: borderRadiusDefault),
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
      backgroundColor: context.theme.scaffoldBackgroundColor,
      surfaceTintColor: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: paddingDefault,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "${'feedback'.tr}/${'report'.tr}",
              style: headlineSmall(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingMedium),
            // Subtitle
            Text(
              "is_this_the_result_you_were_expecting".tr,
              style: bodyLarge(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingLarge),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    color: context.theme.cardColor,
                    icon: Icon(
                      Iconsax.dislike,
                      color: context.theme.disabledColor,
                    ),
                    text: "",
                    onPressed: showReportDialog,
                  ),
                ),
                SizedBox(width: spacingDefault),
                Expanded(
                  child: PrimaryButton(
                    icon: Icon(Iconsax.like_1, color: context.theme.disabledColor),
                    color: context.theme.cardColor,
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
      shape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      surfaceTintColor: context.theme.shadowColor,
      child: Padding(
        padding: paddingDefault,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${'feedback'.tr}/${'report'.tr}",
              style: headlineSmall(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingMedium),
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
            SizedBox(height: spacingDefault),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                color: context.theme.cardColor,
                textColor: bodyLarge(context).color,
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

import 'package:pixart_app/modules/image_generation/history/presentation/controller/history_controller.dart';
import '../../../../../../imports.dart';
import '../../controller/image_generation_result_controller.dart';

class PromptReportButton extends StatelessWidget {
  const PromptReportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.sp,
      right: 10.sp,
      child: InkWell(
        onTap: showFeedbackDialog,
        borderRadius: AppRadius.circular16,
        child: Container(
          padding: AppPadding.padding8,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: AppRadius.circular16),
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
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text("${'feedback'.tr}/${'report'.tr}", style: context.font24, textAlign: TextAlign.center),
            SizedBox(height: 12.sp),
            // Subtitle
            Text(
              "is_this_the_result_you_were_expecting".tr,
              style: context.font16,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.sp),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    color: context.theme.cardColor,
                    icon: Icon(Iconsax.dislike, color: context.theme.disabledColor),
                    text: "",
                    onPressed: showReportDialog,
                  ),
                ),
                SizedBox(width: 16.sp),
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

  void _like() {
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
      shape: RoundedRectangleBorder(borderRadius: AppRadius.circular16),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      surfaceTintColor: context.theme.shadowColor,
      child: Padding(
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${'feedback'.tr}/${'report'.tr}", style: context.font24, textAlign: TextAlign.center),
            SizedBox(height: 12.sp),
            RadioListTile<String>(
              visualDensity: VisualDensity.compact,
              activeColor: primaryColor, // Custom active color
              title: Text("result_is_not_accurate".tr, style: context.font16),
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
              title: Text("inappropriate_content".tr, style: context.font16),
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
                color: context.theme.cardColor,
                textColor: context.font16.color,
                text: "submit".tr,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (selectedOption == null) {
      return;
    }
    showLoading();
    Future.delayed(const Duration(milliseconds: 500), () {
      dismiss();
      if (selectedOption == 'inappropriate') {
        _deleteResult();
      }
      pop(2);
      showToast("feedback_submitted_successfully", success: true);
    });
  }

  void _deleteResult() {
    final response = ImageGenerationResultController.find.imageGenerationResult;
    HistoryController.find.deletePrompt(response!);
    pop();
  }
}

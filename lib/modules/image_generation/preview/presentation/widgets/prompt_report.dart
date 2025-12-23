import 'package:pixart_app/modules/image_generation/history/presentation/controller/history_controller.dart';
import '../../../../../imports.dart';
import '../../../home/data/model/image_generation.dart';
import '../../../home/presentation/controller/image_generation_controller.dart';

class FeedbackSheeet extends StatelessWidget {
  const FeedbackSheeet({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageGenerationResult? result = ImageGenerationController.find.result;
    return Container(
      decoration: BoxDecoration(
        color: context.theme.bottomSheetTheme.backgroundColor,
        borderRadius: AppRadius.top(16),
      ),
      child: Stack(
        children: [
          Positioned(right: 16.sp, top: 16.sp, child: PrimaryCloseButton()),
          Padding(
            padding: AppPadding.padding16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Transform.rotate(
                        angle: -0.05, // Small tilt angle in radians (~3 degrees)
                        child: Container(
                          padding: AppPadding.padding4,
                          decoration: BoxDecoration(
                            color: context.theme.canvasColor,
                            borderRadius: AppRadius.circular16,
                          ),
                          child: ClipRRect(
                            borderRadius: AppRadius.circular12,
                            child: CachedNetworkImage(
                              imageUrl: result!.output.first,
                              width: 70.sp,
                              height: 100.sp,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Center(child: Icon(Iconsax.image, size: 30.sp)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // delete icon,
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: AppPadding.padding4,
                        decoration: BoxDecoration(
                          color: context.theme.bottomSheetTheme.backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: AppPadding.padding8,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: primaryLight),
                          child: Icon(Iconsax.flag, size: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.sp),
                // Title
                Text(
                  "${'feedback'.tr}/${'report'.tr}",
                  style: context.font20.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
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
                        color: context.theme.canvasColor,
                        icon: Icon(Iconsax.dislike, color: context.theme.disabledColor),
                        text: "",
                        onPressed: () {
                          Get.bottomSheet(const ReportingSheet());
                        },
                      ),
                    ),
                    SizedBox(width: 16.sp),
                    Expanded(
                      child: PrimaryButton(
                        icon: Icon(Iconsax.like_1, color: context.theme.disabledColor),
                        color: context.theme.canvasColor,
                        text: "",
                        onPressed: _like,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _like() {
    showLoading();
    Future.delayed(const Duration(seconds: 1), () {
      dismiss();
      pop();
      showToast("feedback_submitted_successfully");
    });
  }
}

class ReportingSheet extends StatefulWidget {
  const ReportingSheet({super.key});

  @override
  State<ReportingSheet> createState() => _ReportingSheetState();
}

class _ReportingSheetState extends State<ReportingSheet> {
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.bottomSheetTheme.backgroundColor,
        borderRadius: AppRadius.top(16),
      ),
      child: Stack(
        children: [
          Positioned(right: 8.sp, top: 8.sp, child: PrimaryCloseButton()),
          Padding(
            padding: AppPadding.padding16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${'feedback'.tr}/${'report'.tr}", style: context.font20, textAlign: TextAlign.center),
                SizedBox(height: 12.sp),
                RadioListTile<String>(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
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
                  contentPadding: EdgeInsets.zero,
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
                    color: context.theme.canvasColor,
                    textColor: context.font16.color,
                    text: "submit".tr,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      showToast("feedback_submitted_successfully");
    });
  }

  void _deleteResult() {
    final response = ImageGenerationController.find.result;
    HistoryController.find.deletePrompt(response!);
    pop();
  }
}

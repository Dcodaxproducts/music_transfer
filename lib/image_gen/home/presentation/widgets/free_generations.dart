import 'package:pixart_app/imports.dart';
import 'package:pixart_app/core/widgets/gradient_widget.dart';
import '../../../../features/paywall/presentation/controller/subscription_controller.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';
import '../controller/generation_controller.dart';

class FreeGenerationLeftWidget extends StatelessWidget {
  const FreeGenerationLeftWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingCon) {
        return GetBuilder<GenerationController>(
          builder: (con) => Visibility(
            visible: settingCon.settingModel.freeGenerations > 0 && !SubscriptionController.find.isPro,
            child: Padding(
              padding: EdgeInsets.only(top: 8.sp),
              child: Center(
                child: Text(
                  "${(settingCon.settingModel.freeGenerations - GenerationController.find.dailyGenerationCount)} ${'free_generations_are_left_for_today'.tr}",
                  style: context.font12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future showFreeLimitDialog() => Get.dialog(const FreeLimitDialog());

class FreeLimitDialog extends StatelessWidget {
  const FreeLimitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: AppPadding.padding16,
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
              child: Icon(Iconsax.warning_2, size: 100.sp, color: Colors.white),
            ),
            SizedBox(height: 16.sp),
            Text("free_limit_reached".tr, style: context.font16.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 16.sp),
            Text("free_limit_reached_message1".tr, style: context.font14, textAlign: TextAlign.center),
            Padding(
              padding: EdgeInsets.only(top: 32.sp),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(text: 'go_pro'.tr, onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

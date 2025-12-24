import 'package:flutter/scheduler.dart';
import 'package:pixart_app/features/paywall/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import '../../../../imports.dart';

Future showAdsDialog({required Function() onWatchAdPressed}) =>
    Get.dialog(AdsDialog(onWatchAdPressed: onWatchAdPressed));

class AdsDialog extends StatefulWidget {
  final Function() onWatchAdPressed;
  const AdsDialog({super.key, required this.onWatchAdPressed});

  @override
  State<AdsDialog> createState() => _AdsDialogState();
}

class _AdsDialogState extends State<AdsDialog> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      SettingsController settings = SettingsController.find;
      settings.configModel = settings.configModel.copyWith(hasViewdAdsDialog: true);
    });
    super.initState();
  }

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
            SizedBox(height: 8.sp),
            Text(
              "you're_using_the_free_version".tr,
              style: context.font16.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.sp),
            Text(
              "${"to_keep_this_service_free_ads_are_displayed_during_your_experience".tr}${"upgrade_to_an_ad-free_experience".tr}",
              style: context.font14,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.sp),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryOutlineButton(text: 'watch_ad'.tr, onPressed: widget.onWatchAdPressed),
                  ),
                  SizedBox(width: 16.sp),
                  Expanded(
                    child: PrimaryButton(
                      text: 'go_pro'.tr,
                      onPressed: () {
                        SubscriptionController.find.showPaywallIfNeeded();
                      },
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

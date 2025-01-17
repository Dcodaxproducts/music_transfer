import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/subscription_controller.dart';
import 'package:matrix_ai/view/base/common/primary_button.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';
import '../../../utils/style.dart';

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
            SizedBox(height: spacingSmall),
            Text(
              "you're_using_the_free_version".tr,
              style: bodyLarge(context).copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: spacingDefault),
            Text(
              SubscriptionController.find.products.isNotEmpty
                  ? "${"to_keep_this_service_free_ads_are_displayed_during_your_experience".tr}${"upgrade_to_an_ad-free_experience".tr}"
                  : "to_keep_this_service_free_ads_are_displayed_during_your_experience".tr,
              style: bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: spacingExtraLarge),
              child: Row(
                children: [
                  Expanded(
                      child: PrimaryOutlineButton(text: 'watch_ad'.tr, onPressed: widget.onWatchAdPressed)),
                  if (SubscriptionController.find.products.isNotEmpty) ...[
                    SizedBox(width: spacingDefault),
                    Expanded(child: PrimaryButton(text: 'go_pro'.tr, onPressed: showPremiumSheet)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

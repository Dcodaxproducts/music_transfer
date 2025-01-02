import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
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
              "You're Using the Free Version".tr,
              style: bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: spacingDefault),
            Text(
              "To keep this service free, ads are displayed during your experience. Upgrade to an Ad-free experience!"
                  .tr,
              style: bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: spacingExtraLarge),
              child: Row(
                children: [
                  Expanded(child: PrimaryOutlineButton(text: 'Watch Ad', onPressed: widget.onWatchAdPressed)),
                  SizedBox(width: spacingDefault),
                  Expanded(child: PrimaryButton(text: 'Go Pro'.tr, onPressed: showPremiumSheet)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

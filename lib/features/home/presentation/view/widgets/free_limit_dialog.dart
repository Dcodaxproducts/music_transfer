import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/core/widgets/gradient_widget.dart';
import 'package:matrix_ai/features/subscription/presentation/view/subscription.dart';
import '../../../../subscription/presentation/controller/subscription_controller.dart';

Future showFreeLimitDialog() => Get.dialog(const FreeLimitDialog());

class FreeLimitDialog extends StatelessWidget {
  const FreeLimitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    bool subscriptionAvailable = SubscriptionController.find.products.isNotEmpty;
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
              child: Icon(Iconsax.warning_2, size: 100.sp, color: Colors.white),
            ),
            SizedBox(height: spacingDefault),
            Text(
              "free_limit_reached".tr,
              style: bodyLarge(context).copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: spacingDefault),
            Text(
              subscriptionAvailable ? "free_limit_reached_message1".tr : "free_limit_reached_message2".tr,
              style: bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: spacingExtraLarge),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: subscriptionAvailable ? 'go_pro'.tr : 'continue'.tr,
                  onPressed: subscriptionAvailable ? showPremiumSheet : Get.back,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:pixart_app/features/subscription/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/subscription/presentation/view/subscription.dart';

class SubsriptionButton extends StatelessWidget {
  const SubsriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (con) {
        return Visibility(
          visible: !con.isPro,
          child: TextButton(
            onPressed: showPremiumSheet,
            style: TextButton.styleFrom(
              padding: AppPadding.padding8,
              visualDensity: VisualDensity.comfortable,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circular8),
            ),
            child: Wrap(
              spacing: 5.sp,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Iconsax.crown_1, color: Colors.white, size: 16.sp),
                Text(
                  'go_pro'.tr,
                  style: context.font12.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

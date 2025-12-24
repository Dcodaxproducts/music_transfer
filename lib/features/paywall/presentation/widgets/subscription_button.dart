import 'package:pixart_app/imports.dart';
import '../controller/subscription_controller.dart';

class SubsriptionButton extends StatelessWidget {
  const SubsriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (con) {
        return Visibility(
          visible: !con.isPro,
          child: TextButton(
            onPressed: () {
              SubscriptionController.find.showPaywallIfNeeded();
            },
            style: TextButton.styleFrom(
              padding: AppPadding.cardPadding,
              visualDensity: VisualDensity.comfortable,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circular32),
            ),
            child: Wrap(
              spacing: 5.sp,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Iconsax.crown_1, color: Colors.white, size: 16.sp),
                Text('go_pro'.tr, style: context.font12.copyWith(color: Colors.white)),
              ],
            ),
          ),
        );
      },
    );
  }
}

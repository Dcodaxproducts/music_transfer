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
              minimumSize: Size(75.sp, 40.sp),
              visualDensity: VisualDensity.comfortable,
              backgroundColor: primaryColor.withOpacity(0.25),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circular32),
            ),
            child: Wrap(
              spacing: 5.sp,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Iconsax.crown, color: primaryLight, size: 14.sp),
                Text(
                  'PRO',
                  style: context.font12.copyWith(color: primaryLight, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

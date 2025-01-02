import 'package:matrix_ai/controller/subscription_controller.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';

class SubsriptionButton extends StatelessWidget {
  const SubsriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (con) {
      return Visibility(
        visible: !con.isPro,
        child: TextButton(
          onPressed: showPremiumSheet,
          style: TextButton.styleFrom(
            padding: paddingSmall,
            visualDensity: VisualDensity.comfortable,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadiusSmall),
          ),
          child: Wrap(
            spacing: 5.sp,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Iconsax.crown_1, color: Colors.white, size: spacingDefault),
              Text('go_pro'.tr, style: bodySmall(context).copyWith(color: Colors.white))
            ],
          ),
        ),
      );
    });
  }
}

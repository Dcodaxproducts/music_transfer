import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import '../../../../imports.dart';
import '../../../paywall/presentation/controller/subscription_controller.dart';

class CreditsWidget extends StatelessWidget {
  const CreditsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        int credits = AuthController.find.user?.credits ?? 0;
        return Container(
          padding: AppPadding.padding12,
          decoration: BoxDecoration(
            borderRadius: AppRadius.circular16,
            border: Border.all(color: context.theme.dividerColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'generation_credits_left'.tr,
                      style: context.font12.copyWith(color: context.theme.hintColor),
                    ),
                    SizedBox(height: 8.sp),
                    Text('$credits', style: context.font16.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (SubscriptionController.find.isPro) {
                    SubscriptionController.find.showPurchaseCreditsPaywall();
                  } else {
                    SubscriptionController.find.showPaywall();
                  }
                },
                borderRadius: AppRadius.circular12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                  decoration: BoxDecoration(
                    color: primaryLight.withOpacity(0.15),
                    borderRadius: AppRadius.circular12,
                  ),
                  child: Row(
                    children: [
                      Image.asset(Images.sparkle, width: 14.sp, height: 14.sp, color: primaryLight),
                      SizedBox(width: 4.sp),
                      Text('get_credits'.tr, style: context.font10.copyWith(color: primaryLight)),
                      SizedBox(width: 4.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import '../../../../imports.dart';
import '../../../paywall/presentation/controller/subscription_controller.dart';

class CreditsWidget extends StatelessWidget {
  const CreditsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
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
                      'Generation credits left',
                      style: context.font12.copyWith(color: context.theme.hintColor),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      '${controller.credits}',
                      style: context.font16.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: SubscriptionController.find.showPaywallIfNeeded,
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
                      Text('Get credits', style: context.font10.copyWith(color: primaryLight)),
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

import '../../../../imports.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../auth/presentation/view/login_screen.dart';
import '../../../dashboard/presentation/controller/dashboard_controller.dart';

Future<void> showPurchaseSuccess(Function() onSuccess) async {
  return await launchScreen(ProSuccessScreen(onSuccess: onSuccess));
}

class ProSuccessScreen extends StatelessWidget {
  final Function() onSuccess;
  const ProSuccessScreen({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        DashboardController.find.toHome();
        onSuccess();
      },
      child: Scaffold(
        body: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Images.logo, height: 150.sp, color: primaryLight),
                    SizedBox(height: 32.sp),

                    Text(
                      'welcome_to_pixart_pro'.tr,
                      style: context.font22.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'unlocked_features_description'.tr,
                      style: context.font16,
                      textAlign: TextAlign.center,
                    ),

                    // Guest user warning banner
                    GetBuilder<AuthController>(
                      builder: (authController) {
                        final bool isGuest = !authController.isLoggedIn;

                        if (!isGuest) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            SizedBox(height: 24.sp),
                            Column(
                              children: [
                                Text(
                                  'guest_credits_warning_title'.tr,
                                  style: context.font14.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 8.sp),
                                Text(
                                  'guest_credits_warning_message'.tr,
                                  style: context.font14.copyWith(color: context.theme.hintColor),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12.sp),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.orange),
                                    foregroundColor: Colors.orange,
                                  ),
                                  onPressed: () => launchScreen(const LoginScreen()),
                                  child: Text('sign_in_to_save_credits'.tr),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                text: 'start_exploring_pro'.tr,
                onPressed: () {
                  DashboardController.find.toHome();
                  Get.back();
                  onSuccess();
                },
              ),
              const SafeArea(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

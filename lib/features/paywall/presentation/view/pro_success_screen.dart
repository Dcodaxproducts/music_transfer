import '../../../../imports.dart';
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
                    SizedBox(height: 26.sp),
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

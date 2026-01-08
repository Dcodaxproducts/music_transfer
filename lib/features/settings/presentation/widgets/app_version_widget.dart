import 'package:pixart_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pixart_app/imports.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (con) {
        return Visibility(
          visible: con.packageInfo != null,
          child: Padding(
            padding: EdgeInsets.only(top: 16.sp),
            child: Center(
              child: Text(
                '${'version'.tr} ${con.packageInfo?.version} (${con.packageInfo?.buildNumber})',
                style: context.font14.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
          ),
        );
      },
    );
  }
}

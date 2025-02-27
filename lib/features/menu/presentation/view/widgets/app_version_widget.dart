import 'package:matrix_ai/features/settings/presentation/controller/settings_controller.dart';
import 'package:matrix_ai/imports.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (con) {
      return Visibility(
        visible: con.packageInfo != null,
        child: Padding(
          padding: EdgeInsets.only(top: spacingDefault),
          child: Center(
            child: Text(
              '${'version'.tr} ${con.packageInfo?.version} (${con.packageInfo?.buildNumber})',
              style: bodyMedium(context).copyWith(color: Theme.of(context).hintColor),
            ),
          ),
        ),
      );
    });
  }
}

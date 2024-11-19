import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/settings_controller.dart';

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
          padding: EdgeInsets.only(top: 16.sp),
          child: Center(
            child: Text(
              '${'version'.tr} ${con.packageInfo?.version} (${con.packageInfo?.buildNumber})',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
          ),
        ),
      );
    });
  }
}

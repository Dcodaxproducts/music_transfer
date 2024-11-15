import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/utils/style.dart';
import '../../../../common/network_image.dart';
import '../../../../common/primary_button.dart';
import '../../../../controller/dashboard_controller.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../data/model/response/inspiration.dart';
import '../../../../helper/navigation.dart';

class InspirationDialog extends StatelessWidget {
  final Inspiration inspiration;
  const InspirationDialog({required this.inspiration, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 30.sp),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Container(
        height: 450.sp,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: borderRadius,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: borderRadius,
              child: CustomNetworkImage(
                url: inspiration.image,
                fit: BoxFit.cover,
              ),
            ),

            // shadow,
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
            ),
            // close button
            Positioned(
              top: 10.sp,
              right: 10.sp,
              child: InkWell(
                onTap: pop,
                child: Container(
                  padding: EdgeInsets.all(5.sp),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    inspiration.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 16.sp),
                  PrimaryButton(
                    text: 'try_now'.tr,
                    onPressed: () {
                      final settings = SettingsController.find;
                      pop();
                      DashboardController.find.selectedIndex = 0;
                      settings.configModel =
                          settings.configModel.copyWith(seed: inspiration.seed);
                      settings.promptController.text = inspiration.prompt;
                      settings.seedController.text =
                          inspiration.seed.toString();
                    },
                  ),
                  SizedBox(height: 16.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

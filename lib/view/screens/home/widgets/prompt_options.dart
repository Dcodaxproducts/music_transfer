import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../data/model/body/aspect_ratio.dart';
import '../../../../utils/style.dart';
import '../../aspect_ratio/aspect_ratio.dart';
import '../../settings/settings.dart';

class PromptSettingsWidget extends StatelessWidget {
  const PromptSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 22.sp),
        Text(
          'advance_options'.tr,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: borderRadius,
                onTap: () => Get.bottomSheet(const AspectRatioScreen(),
                    isScrollControlled: true),
                child: Container(
                  height: 55.sp,
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: borderRadius,
                  ),
                  child: Row(
                    children: [
                      GetBuilder<SettingsController>(builder: (con) {
                        final aspectRatio = aspectRatios.firstWhere(
                            (e) => e.id == con.configModel.aspectRatio);
                        return Text(
                          '${aspectRatio.width} x ${aspectRatio.height}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      }),
                      const Spacer(),
                      Icon(Iconsax.image, size: 18.sp),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                borderRadius: borderRadius,
                onTap: () => Get.bottomSheet(const SettingScreen(),
                    isScrollControlled: true),
                child: Container(
                  height: 55.sp,
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: borderRadius,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'prompt_settings'.tr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Icon(Iconsax.setting_4, size: 18.sp),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

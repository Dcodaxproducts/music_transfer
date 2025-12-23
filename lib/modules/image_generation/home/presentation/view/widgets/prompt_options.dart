import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pixart_app/core/design/design_system.dart';
import '../../../../prompt_setting/presentation/controller/settings_controller.dart';
import '../../../../aspect_ratio/data/model/aspect_ratio.dart';
import '../../../../aspect_ratio/presentation/view/aspect_ratio.dart';
import '../../../../prompt_setting/presentation/view/prompt_setting.dart';

class PromptSettingsWidget extends StatelessWidget {
  const PromptSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.sp),
        Text(
          'advance_options'.tr,
          style: context.font14.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: GetBuilder<SettingsController>(
                builder: (con) {
                  final aspectRatio = aspectRatios.firstWhere(
                    (e) => e.id == con.configModel.aspectRatio,
                  );
                  return PromptOptionButton(
                    title: '${aspectRatio.width} x ${aspectRatio.height}',
                    icon: Iconsax.image,
                    onTap: () => Get.bottomSheet(
                      const AspectRatioScreen(),
                      isScrollControlled: true,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: PromptOptionButton(
                title: 'prompt_settings'.tr,
                icon: Iconsax.setting_4,
                onTap: () => Get.bottomSheet(
                  const PromptSettingScreen(),
                  isScrollControlled: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PromptOptionButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function() onTap;
  const PromptOptionButton({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.circular16,
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: AppRadius.circular16),
        child: Container(
          height: 55.sp,
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: AppRadius.circular16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.font14),
              if (icon != null) Icon(icon, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}

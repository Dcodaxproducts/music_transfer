import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../prompt_setting/presentation/controller/settings_controller.dart';
import '../../../../aspect_ratio/data/model/aspect_ratio.dart';
import '../../../../../../core/utils/style.dart';
import '../../../../aspect_ratio/presentation/view/aspect_ratio.dart';
import '../../../../prompt_setting/presentation/view/prompt_setting.dart';

class PromptSettingsWidget extends StatelessWidget {
  const PromptSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacingDefault),
        Text('advance_options'.tr, style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: spacingSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: GetBuilder<SettingsController>(builder: (con) {
                final aspectRatio = aspectRatios.firstWhere((e) => e.id == con.configModel.aspectRatio);
                return PromptOptionButton(
                  title: '${aspectRatio.width} x ${aspectRatio.height}',
                  icon: Iconsax.image,
                  onTap: () => Get.bottomSheet(const AspectRatioScreen(), isScrollControlled: true),
                );
              }),
            ),
            SizedBox(width: spacingDefault),
            Expanded(
              child: PromptOptionButton(
                title: 'prompt_settings'.tr,
                icon: Iconsax.setting_4,
                onTap: () => Get.bottomSheet(const PromptSettingScreen(), isScrollControlled: true),
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
  const PromptOptionButton({super.key, required this.title, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadiusDefault,
      onTap: onTap,
      child: Container(
        height: 55.sp,
        padding: EdgeInsets.symmetric(horizontal: spacingDefault),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: borderRadiusDefault,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: bodyMedium(context)),
            if (icon != null) Icon(icon, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

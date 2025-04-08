import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/features/tools/data/model/tools.dart';
import 'package:matrix_ai/core/helper/navigation.dart';
import 'package:matrix_ai/features/upscale_image/presentation/view/upscale_image.dart';
import '../../../../../core/utils/style.dart';
import '../../../../settings/presentation/view/widgets/menu_item.dart';
import '../../controller/image_generation_result_controller.dart';

class PromptEditButton extends StatelessWidget {
  const PromptEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.sp,
      right: 10.sp,
      child: InkWell(
        onTap: showActionSheet,
        borderRadius: borderRadiusDefault,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: spacingDefault, vertical: spacingMedium),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: borderRadiusDefault),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.edit, size: spacingDefault, color: Colors.white),
              SizedBox(width: spacingSmall),
              Text('edit'.tr, style: bodyMedium(context).copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

showActionSheet() => Get.bottomSheet(const ActionSheet());

class ActionSheet extends StatefulWidget {
  const ActionSheet({super.key});

  @override
  State<ActionSheet> createState() => _ActionSheetState();
}

class _ActionSheetState extends State<ActionSheet> {
  List<MenuItem> items = [
    MenuItem(
      text: 'ai_upscale'.tr,
      subtile: 'upscale_images_to_higher_resolutions'.tr,
      icon: Iconsax.magicpen,
      onTap: () async {
        pop();
        launchScreen(UpscaleImageScreen(
          tool: ToolModel.upscaleImageTool,
          imageUrl: ImageGenerationResultController.find.imageUrl,
        ));
      },
    ),
    MenuItem(
      text: 'ai_bg_remover'.tr,
      subtile: 'remove_background_easily'.tr,
      icon: Iconsax.eraser_1,
      onTap: () async {
        pop();
        launchScreen(UpscaleImageScreen(
          tool: ToolModel.backgroundRemoverTool,
          imageUrl: ImageGenerationResultController.find.imageUrl,
        ));
      },
    ),
  ];

  //
  Widget get divider => Divider(color: context.theme.scaffoldBackgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingDefault,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: borderRadiusDefault,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.sp,
              height: 4.sp,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2.sp),
              ),
            ),
          ),
          SizedBox(height: spacingDefault),
          Text(
            'edit_result'.tr,
            style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.sp),
          Container(
            decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: borderRadiusDefault),
            child: ListView.separated(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => divider,
              itemBuilder: (context, index) => items[index],
            ),
          ),
        ],
      ),
    );
  }
}

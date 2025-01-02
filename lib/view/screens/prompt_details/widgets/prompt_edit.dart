import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/controller/subscription_controller.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';
import '../../../../helper/navigation.dart';
import '../../../../utils/style.dart';
import '../../menu/widgets/menu_item.dart';

class PromptEditButton extends StatelessWidget {
  const PromptEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool visible = ImageGenerationController.find.promptResponse != null &&
        ImageGenerationController.find.promptResponse!.model!.apiParameters.containsKey('upscale') &&
        ImageGenerationController.find.promptResponse!.model!.apiParameters.containsKey('highres_fix');
    return Visibility(
      visible: visible,
      child: Positioned(
        bottom: 10.sp,
        right: 10.sp,
        child: InkWell(
          onTap: showActionSheet,
          borderRadius: borderRadiusDefault,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: spacingDefault, vertical: spacingMedium),
            decoration:
                BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: borderRadiusDefault),
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
      text: 'face_fix',
      subtile: 'improve_face_realism_in_your_art_with_ai',
      icon: Iconsax.user,
      onTap: () {
        if (!isPro && Platform.isIOS) {
          showPremiumSheet();
          return;
        }
        pop();
        ImageGenerationController api = ImageGenerationController.find;
        api
            .generateImages(
          api.promptResponse!.meta.prompt,
          seed: api.promptResponse?.meta.seed,
          faceFix: true,
          model: api.promptResponse!.model,
        )
            .then((response) {
          if (response != null) {
            api.promptResponse = response;
          } else {
            pop();
          }
        });
      },
    ),
    MenuItem(
      text: 'ai_enhance',
      subtile: 'remove_noise_and_sharpen_images_with_ai',
      icon: Iconsax.magicpen,
      onTap: () {
        if (!isPro && Platform.isIOS) {
          showPremiumSheet();
          return;
        }
        pop();
        ImageGenerationController api = ImageGenerationController.find;
        api
            .generateImages(
          api.promptResponse!.meta.prompt,
          seed: api.promptResponse?.meta.seed,
          upscale: true,
          model: api.promptResponse!.model,
        )
            .then((response) {
          if (response != null) {
            api.promptResponse = response;
          } else {
            pop();
          }
        });
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
            style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
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

// iOS_2.2(3)
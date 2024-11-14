import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import '../../../../helper/navigation.dart';
import '../../../../utils/style.dart';
import '../../menu/menu.dart';

class PromptEditButton extends StatelessWidget {
  const PromptEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.sp,
      right: 10.sp,
      child: InkWell(
        onTap: showActionSheet,
        borderRadius: BorderRadius.circular(16.sp),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.edit, size: 16.sp, color: Colors.white),
              SizedBox(width: 8.sp),
              Text(
                'Edit',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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
      text: 'Face Fix',
      subtile: 'Improve face realism in your art with AI.',
      icon: Iconsax.user,
      onTap: () {
        pop();
        ImageGenerationController api = ImageGenerationController.find;
        api
            .generateImages(
          api.promptResponse!.meta.prompt,
          seed: api.promptResponse?.meta.seed,
          faceFix: true,
          modelId: api.promptResponse!.meta.modelId,
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
      text: 'AI Enhance',
      subtile: 'Remove noise and sharpen images with AI',
      icon: Iconsax.magicpen,
      onTap: () {
        pop();
        ImageGenerationController api = ImageGenerationController.find;
        api
            .generateImages(
          api.promptResponse!.meta.prompt,
          seed: api.promptResponse?.meta.seed,
          upscale: true,
          modelId: api.promptResponse!.meta.modelId,
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
  Widget get divider =>
      Divider(color: Theme.of(context).scaffoldBackgroundColor, height: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: borderRadius,
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
          SizedBox(height: 16.sp),
          Text(
            'Edit Result',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.sp),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: borderRadius,
            ),
            child: ListView.separated(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => divider,
              itemBuilder: (context, index) => items[index],
            ),
          ),
        ],
      ),
    );
  }
}

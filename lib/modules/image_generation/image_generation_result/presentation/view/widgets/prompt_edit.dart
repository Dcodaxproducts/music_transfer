import 'package:pixart_app/features/tools/data/model/tools.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/upscale/image_upscale/presentation/view/upscale_image.dart';
import '../../../../../../features/settings/presentation/view/widgets/menu_item.dart';
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
        borderRadius: AppRadius.circular16,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: AppRadius.circular16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.edit, size: 16.sp, color: Colors.white),
              SizedBox(width: 8.sp),
              Text('edit'.tr, style: context.font14.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> showActionSheet() => Get.bottomSheet(const ActionSheet());

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
        launchScreen(
          UpscaleImageScreen(
            tool: ToolModel.upscaleImageTool,
            imageUrl: ImageGenerationResultController.find.imageUrl,
          ),
        );
      },
    ),
    MenuItem(
      text: 'ai_bg_remover'.tr,
      subtile: 'remove_background_easily'.tr,
      icon: Iconsax.eraser_1,
      onTap: () async {
        pop();
        launchScreen(
          UpscaleImageScreen(
            tool: ToolModel.backgroundRemoverTool,
            imageUrl: ImageGenerationResultController.find.imageUrl,
          ),
        );
      },
    ),
  ];

  //
  Widget get divider => Divider(color: context.theme.scaffoldBackgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.padding16,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: AppRadius.circular16,
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
          Text('edit_result'.tr, style: context.font14.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.sp),
          Container(
            decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: AppRadius.circular16),
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

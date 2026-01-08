import 'package:pixart_app/core/widgets/share_button.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../utils/image_gen_helper.dart';
import '../controller/image_generation_controller.dart';
import 'settings_sheet.dart';

class PromptInputWidget extends StatelessWidget {
  const PromptInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.padding12,
      decoration: BoxDecoration(
        color: context.theme.bottomSheetTheme.backgroundColor,
        borderRadius: AppRadius.top(16),
        border: Border(
          top: BorderSide(color: context.theme.dividerColor),
          left: BorderSide(color: context.theme.dividerColor),
          right: BorderSide(color: context.theme.dividerColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<ImageGenController>(
            builder: (controller) {
              if (controller.attachedImage == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(bottom: 8.sp),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.circular8,
                        child: Image.file(
                          File(controller.attachedImage!.path),
                          width: 90.sp,
                          height: 90.sp,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 2.sp,
                        top: 2.sp,
                        child: GestureDetector(
                          onTap: () => ImageGenController.find.attachedImage = null,
                          child: Container(
                            decoration: BoxDecoration(color: errorColor, shape: BoxShape.circle),
                            padding: EdgeInsets.all(4.sp),
                            child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // text field
          TextFormField(
            maxLines: 5,
            maxLength: 1200,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'enter_prompt_message'.tr,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: '',
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
            style: context.font14,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            controller: ImageGenController.find.promptController,
            onChanged: (value) => ImageGenController.find.update(),
          ),

          SizedBox(height: 12.sp),
          // prompt options
          Row(
            spacing: 8.sp,
            children: [
              ActionButton.small(onPressed: _pickImage, icon: Icons.add),
              ActionButton.small(
                onPressed: () {
                  Get.bottomSheet(const SettingsSheet(), isScrollControlled: true);
                },
                icon: Iconsax.setting_4,
              ),
              const Spacer(),
              GetBuilder<ModelsController>(
                builder: (modelController) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryLight,
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    onPressed: _handleImageGeneration,
                    child: Padding(
                      padding: AppPadding.padding14,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Create', style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(width: 4.sp),
                          Image.asset(Images.sparkle, width: 16.sp, height: 16.sp, color: Colors.white),
                          SizedBox(width: 4.sp),
                          Text(
                            "${modelController.selectedModel?.creditsPerImage ?? 5}",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    ImageGenController.find.attachedImage = image;
    ModelsController.find.handleImageModelSelection();
  }

  Future<void> _handleImageGeneration() async {
    String text = ImageGenController.find.promptController.text.trim();
    await ImageGenerationHelper.handleImageGeneration(text);
  }
}

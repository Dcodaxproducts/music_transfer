import 'package:pixart_app/core/widgets/action_button.dart';
import 'package:pixart_app/features/home/presentation/controller/models_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../utils/image_gen_helper.dart';
import '../controller/image_generation_controller.dart';
import 'settings_sheet.dart';

class PromptInputWidget extends StatelessWidget {
  const PromptInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenController>(
      builder: (controller) {
        bool isEmpty = controller.promptController.text.isEmpty;
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
              if (controller.attachedImages.isEmpty)
                const SizedBox.shrink()
              else
                Padding(
                  padding: EdgeInsets.only(bottom: 8.sp),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 90.sp,
                      child: ListView.separated(
                        itemCount: controller.attachedImages.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, _) => SizedBox(width: 8.sp),
                        itemBuilder: (context, index) {
                          final XFile attachedImage = controller.attachedImages[index];
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: AppRadius.circular8,
                                child: Image.file(
                                  File(attachedImage.path),
                                  width: 90.sp,
                                  height: 90.sp,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 2.sp,
                                top: 2.sp,
                                child: GestureDetector(
                                  onTap: () => controller.removeImageAt(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: errorColor,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(4.sp),
                                    child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
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
                  filled: false,
                ),
                style: context.font14,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                controller: controller.promptController,
                onChanged: (value) => controller.update(),
              ),

              SizedBox(height: 12.sp),
              // prompt options
              Row(
                spacing: 8.sp,
                children: [
                  ActionButton.small(onPressed: _pickImage, icon: Icons.add),
                  const ActionButton.small(onPressed: SettingsSheet.show, icon: Iconsax.setting_4_copy),
                  if (controller.attachedImages.isNotEmpty)
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: primaryLight.withOpacity(0.1)),
                      onPressed: () => ImageGenController.find.clearImages(),
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 14.sp, vertical: 10.sp),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "edit".tr,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: primaryLight),
                            ),
                            SizedBox(width: 4.sp),
                            Icon(Icons.close, size: 16.sp, color: primaryLight),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  GetBuilder<ModelsController>(
                    builder: (modelController) {
                      return AbsorbPointer(
                        absorbing: controller.loading.isNotEmpty,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: isEmpty ? context.theme.disabledColor : primaryLight,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          onPressed: ImageGenerationHelper.handleTap,
                          child: Padding(
                            padding: AppPadding.padding14,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("create".tr, style: const TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(width: 4.sp),
                                Image.asset(Images.sparkle, width: 16.sp, height: 16.sp, color: Colors.white),
                                SizedBox(width: 4.sp),
                                Text(
                                  "${modelController.selectedModel?.creditsPerImage ?? 5}",
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
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
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(limit: 5);
    if (images.isEmpty) return;
    ImageGenController.find.addImages(images);
    ModelsController.find.handleImageModelSelection();
  }
}

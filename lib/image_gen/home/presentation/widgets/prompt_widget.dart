import 'package:pixart_app/core/widgets/share_button.dart';
import 'package:pixart_app/image_gen/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../utils/image_generation_helper.dart';
import 'settings_sheet.dart';

class PromptInputWidget extends StatefulWidget {
  final SettingsController con;
  const PromptInputWidget({required this.con, super.key});

  @override
  State<PromptInputWidget> createState() => _PromptInputWidgetState();
}

class _PromptInputWidgetState extends State<PromptInputWidget> {
  final ValueNotifier<XFile?> _attachedImageNotifier = ValueNotifier(null);

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    _attachedImageNotifier.value = image;
  }

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
          ValueListenableBuilder<XFile?>(
            valueListenable: _attachedImageNotifier,
            builder: (context, attachedImage, _) {
              if (attachedImage == null) {
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
                          onTap: () => _attachedImageNotifier.value = null,
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
            controller: widget.con.promptController,
            onChanged: (value) => widget.con.update(),
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
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryLight,
                  visualDensity: VisualDensity(horizontal: 1, vertical: -1),
                ),
                onPressed: () => _handleImageGeneration(widget.con.promptController.text.trim()),
                child: Padding(
                  padding: AppPadding.cardPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.magicpen, size: 16.sp),
                      SizedBox(width: 4.sp),
                      Text('Create'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Future<void> _handleImageGeneration(String text) async {
    await ImageGenerationHelper.handleImageGeneration(text, generateImage: _generateImage);
  }

  void _generateImage(String text, {bool showAds = true}) {
    ImageGenerationHelper.generateImage(
      text,
      showAds: showAds,
      attachedImage: _attachedImageNotifier.value,
    ).then((_) {
      _attachedImageNotifier.value = null;
    });
  }
}

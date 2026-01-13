import 'package:pixart_app/core/widgets/primary_bottom_sheet.dart';
import 'package:pixart_app/features/tools/presentation/controller/tools_controller.dart';
import 'package:pixart_app/imports.dart';
import 'aspect_ratio.dart';

class ToolImagePicker extends StatefulWidget {
  final Function(XFile image) onImagePicked;
  const ToolImagePicker({super.key, required this.onImagePicked});

  ToolImagePicker.show({super.key, onImagePicked}) : onImagePicked = onImagePicked! {
    Get.bottomSheet(
      ToolImagePicker(onImagePicked: onImagePicked),
      isScrollControlled: true,
      isDismissible: false, // ❌ no tap outside
      enableDrag: false, // ❌ no swipe down
    );
  }

  @override
  State<ToolImagePicker> createState() => _ToolImagePickerState();
}

class _ToolImagePickerState extends State<ToolImagePicker> {
  XFile? selectedImage;

  Future<void> _pickImage() async {
    final value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        selectedImage = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolsController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async => !controller.generatingImage,
          child: AbsorbPointer(
            absorbing: controller.generatingImage,
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.bottomSheetTheme.backgroundColor,
                borderRadius: AppRadius.top(16),
              ),
              child: PrimaryBottomSheet(
                title: 'Select Image',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        height: 350.sp,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.theme.canvasColor,
                          borderRadius: AppRadius.circular16,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (selectedImage != null)
                              ClipRRect(
                                borderRadius: AppRadius.circular16,
                                child: Image.file(File(selectedImage!.path), fit: BoxFit.cover),
                              ),

                            if (selectedImage != null)
                              Positioned(
                                right: 8.sp,
                                top: 8.sp,
                                child: PrimaryCloseButton(
                                  onTap: () {
                                    setState(() {
                                      selectedImage = null;
                                    });
                                  },
                                ),
                              ),
                            if (selectedImage == null)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.export_1, color: primaryLight, size: 26.sp),
                                  SizedBox(height: 8.sp),
                                  Text(
                                    'Upload Image',
                                    style: context.font12.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),

                    if (controller.selectedTool?.model?.sizes != null &&
                        controller.selectedTool!.model!.sizes.isNotEmpty) ...[
                      SizedBox(height: 16.sp),

                      ToolAspectRatio(),
                    ],

                    SizedBox(height: 32.sp),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: controller.generatingImage ? 'Generating...' : 'Continue',
                        isLoading: controller.generatingImage,
                        onPressed: () {
                          if (selectedImage != null) {
                            widget.onImagePicked(selectedImage!);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:pixart_app/features/tools/presentation/controller/tools_controller.dart';
import 'package:pixart_app/imports.dart';

Future<void> pickImage({required Function(XFile image) onImagePicked}) async {
  Get.bottomSheet(
    PickImageSheet(onImagePicked: onImagePicked),
    isScrollControlled: true,
    isDismissible: false, // ❌ no tap outside
    enableDrag: false, // ❌ no swipe down
  );
}

class PickImageSheet extends StatefulWidget {
  final Function(XFile image) onImagePicked;
  const PickImageSheet({super.key, required this.onImagePicked});

  @override
  State<PickImageSheet> createState() => _PickImageSheetState();
}

class _PickImageSheetState extends State<PickImageSheet> {
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
              child: Padding(
                padding: AppPadding.padding16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 24.sp),
                        Text('Select Image'.tr, style: context.font16.copyWith(fontWeight: FontWeight.w600)),
                        PrimaryCloseButton(),
                      ],
                    ),
                    SizedBox(height: 24.sp),
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

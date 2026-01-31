import 'dart:ui';
import 'package:pixart_app/core/widgets/primary_bottom_sheet.dart';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/paywall/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/features/tools/presentation/controller/tools_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../data/model/tools.dart';
import 'aspect_ratio.dart';

class ToolImagePicker extends StatefulWidget {
  final Function(XFile image) onImagePicked;
  final Tool tool;
  const ToolImagePicker({super.key, required this.onImagePicked, required this.tool});

  ToolImagePicker.show({super.key, tool, onImagePicked}) : tool = tool!, onImagePicked = onImagePicked! {
    Get.bottomSheet(
      ToolImagePicker(onImagePicked: onImagePicked, tool: tool),
      isScrollControlled: true,
      isDismissible: false, // ❌ no tap outside
      enableDrag: false, // ❌ no swipe down
    );
  }

  @override
  State<ToolImagePicker> createState() => _ToolImagePickerState();
}

class _ToolImagePickerState extends State<ToolImagePicker> {
  ValueNotifier<XFile?> selectedImage = ValueNotifier<XFile?>(null);

  Future<void> _pickImage() async {
    final value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      selectedImage.value = value;
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
                child: ValueListenableBuilder<XFile?>(
                  valueListenable: selectedImage,
                  builder: (context, value, child) {
                    final XFile? image = value;
                    return Column(
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
                                if (image != null)
                                  ClipRRect(
                                    borderRadius: AppRadius.circular16,
                                    child: Image.file(File(image.path), fit: BoxFit.cover),
                                  ),

                                // Loa,,ding animation overlay
                                if (image != null && controller.generatingImage)
                                  ClipRRect(
                                    borderRadius: AppRadius.circular16,
                                    child: GeneratingOverlay(imagePath: image.path, showText: false),
                                  ),

                                if (image != null && !controller.generatingImage)
                                  Positioned(
                                    right: 8.sp,
                                    top: 8.sp,
                                    child: PrimaryCloseButton(
                                      onTap: () {
                                        selectedImage.value = null;
                                      },
                                    ),
                                  ),
                                if (image == null)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Iconsax.export_1_copy, color: primaryLight, size: 26.sp),
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
                          child: ElevatedButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.generatingImage)
                                  Padding(
                                    padding: AppPadding.horizontal(6),
                                    child: SizedBox(
                                      width: 14.sp,
                                      height: 14.sp,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  ),
                                Text(
                                  controller.generatingImage ? 'Creating...' : 'Create Image',
                                  style: context.font14.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                if (!controller.generatingImage) ...[
                                  Padding(
                                    padding: AppPadding.horizontal(6),
                                    child: Image.asset(
                                      Images.sparkle,
                                      width: 16.sp,
                                      height: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${widget.tool.credits}',
                                    style: context.font14.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            onPressed: () {
                              if (widget.tool.premium && !SubscriptionController.find.isPro) {
                                SubscriptionController.find.showPaywall();
                                return;
                              }
                              if (AuthController.find.credits < widget.tool.credits) {
                                showToast('Not enough credits. Please purchase more to continue.');
                                return;
                              }
                              if (image != null) {
                                widget.onImagePicked(image);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GeneratingOverlay extends StatefulWidget {
  final String imagePath;
  final bool showText;
  const GeneratingOverlay({super.key, required this.imagePath, this.showText = true});

  @override
  State<GeneratingOverlay> createState() => _GeneratingOverlayState();
}

class _GeneratingOverlayState extends State<GeneratingOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();

    // Single controller for better performance
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)..repeat();

    // Scan line animation (0 to 1)
    _scanLineAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred background image (static - no rebuild needed)
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Image.file(File(widget.imagePath), fit: BoxFit.cover),
        ),

        // Dark overlay (static)
        Container(color: Colors.black.withOpacity(0.5)),

        // Scan line effect (moving from top to bottom)
        AnimatedBuilder(
          animation: _scanLineAnimation,
          builder: (context, child) =>
              Positioned(top: _scanLineAnimation.value * 350.sp, left: 0, right: 0, child: child!),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, primaryLight.withOpacity(0.9), Colors.transparent],
              ),
              boxShadow: [BoxShadow(color: primaryLight.withOpacity(0.6), blurRadius: 15, spreadRadius: 3)],
            ),
          ),
        ),

        // Simple "Generating..." text at bottom (static),
        if (widget.showText)
          Positioned(
            bottom: 32.sp,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: AppPadding.cardPadding,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: AppRadius.circular32,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16.sp,
                      height: 16.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryLight),
                      ),
                    ),
                    SizedBox(width: 12.sp),
                    Text(
                      'Generating your image...',
                      style: context.font14.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

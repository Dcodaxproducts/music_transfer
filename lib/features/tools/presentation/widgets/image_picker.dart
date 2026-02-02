import 'dart:ui';
import 'package:pixart_app/core/widgets/primary_bottom_sheet.dart';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/paywall/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/features/tools/presentation/controller/tools_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../data/model/tools.dart';
import 'aspect_ratio.dart';

class ToolImagePicker extends StatefulWidget {
  final Function(List<XFile> images) onImagePicked;
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
  late ValueNotifier<List<XFile?>> selectedImages;

  @override
  void initState() {
    super.initState();
    // Initialize list with nulls based on required image count
    selectedImages = ValueNotifier<List<XFile?>>(List.filled(widget.tool.inputImages, null));
  }

  Future<void> _pickImage(int index) async {
    final value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      final updated = List<XFile?>.from(selectedImages.value);
      updated[index] = value;
      selectedImages.value = updated;
    }
  }

  void _removeImage(int index) {
    final updated = List<XFile?>.from(selectedImages.value);
    updated[index] = null;
    selectedImages.value = updated;
  }

  bool get _allImagesSelected {
    return selectedImages.value.every((image) => image != null);
  }

  List<XFile> get _selectedImagesList {
    return selectedImages.value.whereType<XFile>().toList();
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
                title: 'select_image'.tr,
                child: ValueListenableBuilder<List<XFile?>>(
                  valueListenable: selectedImages,
                  builder: (context, images, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.tool.guideline != null) ...[
                          Text(
                            widget.tool.guideline!,
                            style: context.font14.copyWith(color: context.theme.hintColor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.sp),
                        ],
                        _buildImageGrid(context, images, controller),

                        if (controller.selectedTool?.model?.sizes != null &&
                            controller.selectedTool!.model!.sizes.isNotEmpty) ...[
                          SizedBox(height: 16.sp),

                          ToolAspectRatio(),
                        ],

                        SizedBox(height: 32.sp),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: !_allImagesSelected
                                ? null
                                : () {
                                    if (widget.tool.premium && !SubscriptionController.find.isPro) {
                                      SubscriptionController.find.showPaywall();
                                      return;
                                    }
                                    if (AuthController.find.credits < widget.tool.credits) {
                                      SubscriptionController.find.showPurchaseCreditsPaywall();
                                      return;
                                    }
                                    widget.onImagePicked(_selectedImagesList);
                                  },
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
                                  controller.generatingImage ? 'creating'.tr : 'create_image'.tr,
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

  Widget _buildImageGrid(BuildContext context, List<XFile?> images, ToolsController controller) {
    final int count = widget.tool.inputImages;

    // Single image - full width
    if (count == 1) {
      return _ImageUploadSlot(
        image: images[0],
        index: 0,
        onTap: () => _pickImage(0),
        onRemove: () => _removeImage(0),
        showGeneratingOverlay: controller.generatingImage,
        height: 350.sp,
      );
    }

    // Two images - side by side
    if (count == 2) {
      return Row(
        children: [
          Expanded(
            child: _ImageUploadSlot(
              image: images[0],
              index: 0,
              onTap: () => _pickImage(0),
              onRemove: () => _removeImage(0),
              showGeneratingOverlay: controller.generatingImage && images[0] != null,
              height: 180.sp,
            ),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: _ImageUploadSlot(
              image: images[1],
              index: 1,
              onTap: () => _pickImage(1),
              onRemove: () => _removeImage(1),
              showGeneratingOverlay: controller.generatingImage && images[1] != null,
              height: 180.sp,
            ),
          ),
        ],
      );
    }

    // 3+ images - grid layout
    final int crossAxisCount = count >= 4 ? 2 : 2;
    final double itemHeight = count >= 4 ? 170.sp : 230.sp;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12.sp,
        mainAxisSpacing: 12.sp,
        childAspectRatio: 1.0,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        return _ImageUploadSlot(
          image: images[index],
          index: index,
          onTap: () => _pickImage(index),
          onRemove: () => _removeImage(index),
          showGeneratingOverlay: controller.generatingImage && images[index] != null,
          height: itemHeight,
        );
      },
    );
  }
}

// Reusable image upload slot widget
class _ImageUploadSlot extends StatelessWidget {
  final XFile? image;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool showGeneratingOverlay;
  final double height;

  const _ImageUploadSlot({
    required this.image,
    required this.index,
    required this.onTap,
    required this.onRemove,
    this.showGeneratingOverlay = false,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(color: context.theme.canvasColor, borderRadius: AppRadius.circular16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: AppRadius.circular16,
                child: Image.file(File(image!.path), fit: BoxFit.cover),
              ),

            // Loading animation overlay
            if (image != null && showGeneratingOverlay)
              ClipRRect(
                borderRadius: AppRadius.circular16,
                child: GeneratingOverlay(imagePath: image!.path, showText: false),
              ),

            // Close button
            if (image != null && !showGeneratingOverlay)
              Positioned(
                right: 8.sp,
                top: 8.sp,
                child: PrimaryCloseButton(onTap: onRemove),
              ),

            // Empty state
            if (image == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.export_1_copy, color: primaryLight, size: 26.sp),
                  SizedBox(height: 8.sp),
                  Text(
                    index == 0 ? 'upload_image'.tr : 'upload_image'.tr,
                    style: context.font12.copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
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
                      'generating_your_image'.tr,
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

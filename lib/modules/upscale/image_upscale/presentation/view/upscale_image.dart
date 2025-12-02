import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixart_app/imports.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/widgets/gradient_widget.dart';
import '../../../../../core/widgets/network_image.dart';
import '../../../../../features/loading_screen/presentation/view/src/loading_manager.dart';
import '../../../../../features/tools/data/model/tools.dart';
import '../../../../bg_removal/background_remover/presentation/controller/background_remover_controller.dart';
import '../../data/model/upscale_response.dart';
import '../controller/image_upscale_controller.dart';
import 'image_result_screen.dart';
import 'widgets/upscale_history.dart';

class UpscaleImageScreen extends StatefulWidget {
  final ToolModel tool;
  final String? imageUrl;
  const UpscaleImageScreen({super.key, required this.tool, this.imageUrl});

  @override
  State<UpscaleImageScreen> createState() => _UpscaleImageScreenState();
}

class _UpscaleImageScreenState extends State<UpscaleImageScreen> {
  XFile? selectedImage;
  bool isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      await _handleCameraPermission();
    }
    final value = await ImagePicker().pickImage(source: source);
    if (value != null) {
      setState(() {
        selectedImage = value;
      });
    }
  }

  Future<void> _handleCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _handleApiCall() async {
    UpscaleResponse? response;

    File? file;
    if (selectedImage != null) {
      file = File(selectedImage!.path);
    }
    if (widget.tool.backgroundRemover != null) {
      response = await BackgroundRemoverController.find.removeImageBackground(
        image: file,
        tool: widget.tool,
        urlImage: widget.imageUrl,
      );
    } else {
      response = await ImageUpscaleController.find.upscaleImage(
        image: file,
        tool: widget.tool,
        urlImage: widget.imageUrl,
      );
    }
    if (response != null) {
      await LoadingManager.complete();
      launchScreen(ImageResultScreen(response: response), replace: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tool.name.tr), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(
        padding: AppPadding.padding16,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: selectedImage == null && widget.imageUrl == null
                ? _buildUploadSection()
                : _buildSelectedImagePreview(),
          ),
          SizedBox(height: 24.sp),
          UpscaleHistoryList(tool: widget.tool),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return DottedBorder(
      color: context.theme.disabledColor,
      strokeCap: StrokeCap.round,
      dashPattern: const [8, 4],
      borderType: BorderType.RRect,
      radius: Radius.circular(16.sp),
      padding: AppPadding.padding24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // tool description
          Text(
            widget.tool.description.tr,
            style: context.font14.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          // upload image button
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.sp),
            child: PrimaryButton(
              text: 'upload_image',
              icon: Icon(Iconsax.gallery, size: 20.sp),
              color: context.font16.color,
              textColor: context.theme.scaffoldBackgroundColor,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ImageSourceSheet(
                    onSourceSelected: (source) {
                      Navigator.pop(context);
                      _pickImage(source);
                    },
                  ),
                );
              },
            ),
          ),
          // upload image description
          Text(
            widget.tool.backgroundRemover != null
                ? 'To get started, upload your image. AI will remove the background for you.'
                : 'To get started, upload your image. AI will upscale it for you.',
            style: context.font14.copyWith(color: context.theme.hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Column(
      children: [
        SizedBox(
          height: 350.sp,
          child: DottedBorder(
            color: context.theme.disabledColor,
            strokeCap: StrokeCap.round,
            dashPattern: const [8, 4],
            borderType: BorderType.RRect,
            radius: Radius.circular(16.sp),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.circular16,
                  child: widget.imageUrl != null && selectedImage == null
                      ? CustomNetworkImage(url: widget.imageUrl)
                      : Image.file(File(selectedImage!.path), fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ImageSourceSheet(
                          onSourceSelected: (source) {
                            Navigator.pop(context);
                            _pickImage(source);
                          },
                        ),
                      );
                    },
                    borderRadius: AppRadius.bottom(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(borderRadius: AppRadius.bottom(16)),
                      child: Container(
                        height: 60.sp,
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.6),
                          borderRadius: AppRadius.bottom(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Change Image',
                                style: context.font14.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.sp),
        GradientButton(
          text: widget.tool.name.tr,
          icon: GradientWidget(
            child: Icon(Iconsax.magicpen, color: Colors.white, size: 18.sp),
          ),
          onPressed: _handleApiCall,
        ),
      ],
    );
  }
}

class ImageSourceSheet extends StatelessWidget {
  final Function(ImageSource source) onSourceSelected;

  const ImageSourceSheet({required this.onSourceSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.sp),
          Container(
            width: 36.sp,
            height: 4.sp,
            decoration: BoxDecoration(
              color: context.theme.dividerColor,
              borderRadius: BorderRadius.circular(2.sp),
            ),
          ),
          SizedBox(height: 12.sp),
          _buildOption(
            context,
            icon: Iconsax.gallery,
            label: 'Photo Library',
            onTap: () => onSourceSelected(ImageSource.gallery),
          ),
          Divider(height: 1.sp),
          _buildOption(
            context,
            icon: Iconsax.camera,
            label: 'Take Photo',
            onTap: () => onSourceSelected(ImageSource.camera),
          ),
          Divider(height: 16.sp),
          _buildCancelButton(context),
          SizedBox(height: context.mediaQueryPadding.bottom + 8.sp),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20.sp),
            SizedBox(width: 12.sp),
            Text(label, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.sp),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.sp)),
        child: Text(
          'Cancel',
          style: context.font14.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

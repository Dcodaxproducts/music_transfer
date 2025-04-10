import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_ai/core/widgets/gradient_scaffold.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/modules/upscale/image_upscale/presentation/view/image_uploded.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../features/tools/data/model/tools.dart';
import 'widgets/upscale_history.dart';

class UpscaleImageScreen extends StatefulWidget {
  final ToolModel tool;
  final String? imageUrl;
  const UpscaleImageScreen({super.key, required this.tool, this.imageUrl});

  @override
  State<UpscaleImageScreen> createState() => _UpscaleImageScreenState();
}

class _UpscaleImageScreenState extends State<UpscaleImageScreen> {
  Future<void> _pickImage(ImageSource source) async {
    pop();
    if (source == ImageSource.camera) {
      await _handleCameraPermission();
    }
    final value = await ImagePicker().pickImage(source: source);
    if (value != null) {
      launchScreen(ImageUplodedScreen(image: value, tool: widget.tool, source: source));
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

  @override
  void initState() {
    if (widget.imageUrl != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        launchScreen(ImageUplodedScreen(
          tool: widget.tool,
          source: ImageSource.gallery,
          imageUrl: widget.imageUrl,
        ));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: Text(widget.tool.name.tr), backgroundColor: Colors.transparent),
      body: ListView(
        padding: paddingDefault,
        children: [
          DottedBorder(
              color: context.theme.disabledColor,
              strokeCap: StrokeCap.round,
              dashPattern: const [8, 4],
              borderType: BorderType.RRect,
              radius: Radius.circular(radiusDefault),
              padding: paddingLarge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.tool.description.tr,
                    style: bodyMedium(context).copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacingLarge),
                  PrimaryButton(
                    text: 'upload_image',
                    icon: Icon(Iconsax.gallery, size: 20.sp),
                    color: bodyLarge(context).color,
                    textColor: context.theme.scaffoldBackgroundColor,
                    borderRadius: borderRadiusDefault,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ImageSourceSheet(onSourceSelected: _pickImage),
                      );
                    },
                  ),
                  SizedBox(height: spacingLarge),
                  Text(
                    widget.tool.backgroundRemover != null
                        ? 'To get started, upload your image. AI will remove the background for you.'
                        : 'To get started, upload your image. AI will upscale it for you.',
                    style: bodyMedium(context).copyWith(color: context.theme.hintColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
          UpscaleHistoryList(tool: widget.tool),
        ],
      ),
    );
  }
}

class ImageSourceSheet extends StatelessWidget {
  final Function(ImageSource source) onSourceSelected;

  const ImageSourceSheet({
    required this.onSourceSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(spacingDefault)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: spacingSmall),
          Container(
            width: 36.sp,
            height: 4.sp,
            decoration: BoxDecoration(
              color: context.theme.dividerColor,
              borderRadius: BorderRadius.circular(2.sp),
            ),
          ),
          SizedBox(height: spacingMedium),
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
          Divider(height: spacingDefault),
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
            SizedBox(width: spacingMedium),
            Text(
              label,
              style: bodyMedium(context).copyWith(fontWeight: FontWeight.w500),
            ),
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
        padding: EdgeInsets.symmetric(vertical: spacingLarge),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radiusDefault)),
        child: Text(
          'Cancel',
          style: bodyMedium(context).copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

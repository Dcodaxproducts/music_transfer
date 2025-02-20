import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/view/screens/upscale_image/pages/image_uploded.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/model/response/tools.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(width: double.infinity, height: 280.sp, child: widget.tool.animation),
          Padding(
            padding: paddingDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tool.name.tr,
                  style: bodyLarge(context).copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: spacingSmall),
                Text(widget.tool.description.tr, style: bodyMedium(context)),
                SizedBox(height: spacingExtraLarge),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'upload_from_gallery'.tr,
                    icon: Icon(Iconsax.gallery, color: Colors.white, size: 20.sp),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                SizedBox(height: spacingDefault),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryOutlineButton(
                    text: 'take_photo'.tr,
                    icon: Icon(Iconsax.camera, color: primaryColor, size: 20.sp),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ),
                UpscaleHistoryList(tool: widget.tool),
              ],
            ),
          )
        ],
      ),
    );
  }
}

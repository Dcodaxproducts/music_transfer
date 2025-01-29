import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/view/screens/upscale_image/pages/image_uploded.dart';
import '../../../data/model/response/tools.dart';
import 'widgets/upscale_history.dart';

class UpscaleImageScreen extends StatefulWidget {
  final ToolModel tool;
  const UpscaleImageScreen({super.key, required this.tool});

  @override
  State<UpscaleImageScreen> createState() => _UpscaleImageScreenState();
}

class _UpscaleImageScreenState extends State<UpscaleImageScreen> {
  Future<void> _pickImage(ImageSource source) async {
    final value = await ImagePicker().pickImage(source: source);
    if (value != null) {
      launchScreen(ImageUplodedScreen(image: value, tool: widget.tool, source: source));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CachedNetworkImage(imageUrl: widget.tool.image),
          Padding(
            padding: paddingDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tool.name,
                  style: bodyLarge(context).copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: spacingSmall),
                Text(widget.tool.description, style: bodyMedium(context)),
                SizedBox(height: spacingExtraLarge),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Upload from Gallery',
                    icon: Icon(Iconsax.gallery, color: Colors.white, size: 20.sp),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                SizedBox(height: spacingDefault),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryOutlineButton(
                    text: 'Take Photo',
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

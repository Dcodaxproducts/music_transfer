import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_ai/modules/upscale/image_upscale/presentation/controller/image_upscale_controller.dart';
import 'package:matrix_ai/modules/upscale/image_upscale/data/model/upscale_response.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/core/widgets/network_image.dart';
import 'package:matrix_ai/features/loading_screen/presentation/view/src/loading_manager.dart';
import '../../../../../features/tools/data/model/tools.dart';
import '../../../../bg_removal/background_remover/presentation/controller/background_remover_controller.dart';
import 'image_result_screen.dart';

class ImageUplodedScreen extends StatefulWidget {
  final XFile? image;
  final ToolModel tool;
  final ImageSource source;
  final String? imageUrl;
  const ImageUplodedScreen({super.key, this.image, required this.tool, required this.source, this.imageUrl});

  @override
  State<ImageUplodedScreen> createState() => _ImageUplodedScreenState();
}

class _ImageUplodedScreenState extends State<ImageUplodedScreen> {
  bool get _bacgroundRemover => widget.tool.backgroundRemover != null;
  XFile? image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  Future<void> _pickImage() async {
    final value = await ImagePicker().pickImage(source: widget.source);
    if (value != null) {
      setState(() {
        image = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: context.theme.cardColor),
              child: widget.imageUrl != null && image == null
                  ? CustomNetworkImage(url: widget.imageUrl)
                  : Image.file(File(image!.path), fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: spacingDefault),
          Padding(
            padding: paddingDefault,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: _bacgroundRemover ? 'Remove Background' : 'Upscale Image',
                    icon: Icon(Iconsax.magicpen, color: Colors.white, size: 18.sp),
                    onPressed: _handleApiCall,
                  ),
                ),
                SizedBox(height: spacingDefault),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryOutlineButton(text: 'Change Image', onPressed: _pickImage),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _handleApiCall() async {
    UpscaleResponse? response;

    File? file;
    if (image != null) {
      file = File(image!.path);
    }
    if (_bacgroundRemover) {
      response = await BackgroundRemoverController.find
          .removeImageBackground(image: file, tool: widget.tool, urlImage: widget.imageUrl);
    } else {
      response = await ImageUpscaleController.find
          .upscaleImage(image: file, tool: widget.tool, urlImage: widget.imageUrl);
    }
    if (response != null) {
      await LoadingManager.complete();
      launchScreen(ImageResultScreen(response: response), replace: true);
    }
  }
}

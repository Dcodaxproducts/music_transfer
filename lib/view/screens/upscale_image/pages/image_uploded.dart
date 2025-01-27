import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_ai/controller/background_remover_controller.dart';
import 'package:matrix_ai/controller/image_upscale_controller.dart';
import 'package:matrix_ai/data/model/response/upscale_response.dart';
import 'package:matrix_ai/imports.dart';
import '../../../../data/model/response/tools.dart';
import 'image_result_screen.dart';

class ImageUplodedScreen extends StatefulWidget {
  final XFile image;
  final ToolModel tool;
  const ImageUplodedScreen({super.key, required this.image, required this.tool});

  @override
  State<ImageUplodedScreen> createState() => _ImageUplodedScreenState();
}

class _ImageUplodedScreenState extends State<ImageUplodedScreen> {
  bool get _bacgroundRemover => widget.tool.backgroundRemover != null;
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
              child: Image.file(File(widget.image.path), fit: BoxFit.contain),
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
                const SizedBox(
                  width: double.infinity,
                  child: PrimaryOutlineButton(text: 'Change Image', onPressed: pop),
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
    File file = File(widget.image.path);
    if (_bacgroundRemover) {
      response = await BackgroundRemoverController.find.removeImageBackground(image: file, tool: widget.tool);
    } else {
      response = await ImageUpscaleController.find.upscaleImage(image: file, tool: widget.tool);
    }
    if (response != null) {
      launchScreen(ImageResultScreen(response: response), replace: true);
    } else {
      Get.close(1);
    }
  }
}

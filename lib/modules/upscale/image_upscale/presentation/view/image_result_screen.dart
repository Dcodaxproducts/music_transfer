import 'package:matrix_ai/modules/upscale/image_upscale/presentation/controller/image_upscale_controller.dart';
import 'package:matrix_ai/core/helper/image_download.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/core/widgets/confirmation_dialog.dart';
import 'package:matrix_ai/core/widgets/view_image.dart';
import '../../../../bg_removal/background_remover/presentation/controller/background_remover_controller.dart';
import '../../data/model/upscale_response.dart';

class ImageResultScreen extends StatefulWidget {
  final UpscaleResponse response;
  const ImageResultScreen({super.key, required this.response});

  @override
  State<ImageResultScreen> createState() => _ImageResultScreenState();
}

class _ImageResultScreenState extends State<ImageResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ImageViewWithErrorHandling(url: widget.response.output.first),
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
                    onPressed: () {
                      DownloadImage.downloadImage(widget.response.output.first);
                    },
                    text: 'Download Image',
                    icon: Icon(Icons.download, color: Colors.white, size: 18.sp),
                  ),
                ),
                SizedBox(height: spacingDefault),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryOutlineButton(
                    onPressed: _deleteResult,
                    text: 'Delete Image',
                    textColor: Colors.red,
                    icon: Icon(Iconsax.trash, color: Colors.red, size: 18.sp),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _deleteResult() {
    showConfirmationDialog(
      title: 'Delete Result',
      subtitle: "Are you sure you want to result this result?",
      actionText: 'Delete',
      onAccept: () {
        pop();
        if (widget.response.isBackgroundRemover) {
          BackgroundRemoverController.find.removeBackgroundRemovalHistory(widget.response);
        } else {
          ImageUpscaleController.find.removeUpscaleHistory(widget.response);
        }
        Get.back();
      },
    );
  }
}

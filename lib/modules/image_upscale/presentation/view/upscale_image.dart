import 'package:image_picker/image_picker.dart';
import 'package:pixart_app/imports.dart';
import '../../../../core/widgets/image_picker.dart';
import '../../../../features/loading_screen/src/loading_manager.dart';
import '../../../../features/tools/data/model/tools.dart';
import '../../data/model/upscale_result.dart';
import '../controller/image_upscale_controller.dart';
import 'image_result_screen.dart';

class UpscaleImageScreen extends StatefulWidget {
  final ToolModel tool;
  final String? imageUrl;
  const UpscaleImageScreen({super.key, required this.tool, this.imageUrl});

  @override
  State<UpscaleImageScreen> createState() => _UpscaleImageScreenState();
}

class _UpscaleImageScreenState extends State<UpscaleImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: PrimaryBackButton(), title: Text(widget.tool.name.tr)),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 100.sp),
              child: SizedBox(
                height: 500.sp,
                width: double.infinity,
                child: widget.tool.animation ?? SizedBox.shrink(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: AppPadding.padding16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.tool.name.tr, style: context.font18.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.sp),
                  Text(
                    widget.tool.description.tr,
                    style: context.font14.copyWith(color: context.theme.hintColor),
                  ),
                  SizedBox(height: 24.sp),
                  PrimaryButton(
                    text: 'Try Now!',
                    onPressed: () {
                      pickImage(text: 'upscale'.tr, onImagePicked: _handleApiCall);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleApiCall(XFile image) async {
    UpscaleResult? response;
    response = await ImageUpscaleController.find.upscaleImage(image);
    if (response != null) {
      LoadingManager.complete();
      launchScreen(UpscaleResultScreen(response: response), replace: true);
    } else {
      await LoadingManager.error();
    }
  }
}

import 'package:image_picker/image_picker.dart';
import 'package:pixart_app/imports.dart';
import '../../../../core/widgets/image_picker.dart';
import '../../../../features/loading_screen/src/loading_manager.dart';
import '../../../../features/tools/data/model/tools.dart';
import '../../data/model/bg_remover_result.dart';
import '../controller/background_remover_controller.dart';
import 'image_result_screen.dart';

class BgRemoverScreen extends StatefulWidget {
  final ToolModel tool;
  final String? imageUrl;
  const BgRemoverScreen({super.key, required this.tool, this.imageUrl});

  @override
  State<BgRemoverScreen> createState() => _BgRemoverScreenState();
}

class _BgRemoverScreenState extends State<BgRemoverScreen> {
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
                      pickImage(text: 'remove_background'.tr, onImagePicked: _handleApiCall);
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
    BgRemoverResult? response;
    response = await BgRemoverController.find.removeBg(image);
    if (response != null) {
      LoadingManager.complete();
      launchScreen(BgRemoverResultScreen(response: response), replace: true);
    } else {
      await LoadingManager.error();
    }
  }
}

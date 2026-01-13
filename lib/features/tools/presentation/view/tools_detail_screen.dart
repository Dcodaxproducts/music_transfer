import 'package:pixart_app/features/tools/presentation/controller/tools_controller.dart';
import 'package:pixart_app/features/tools/presentation/widgets/image_animation.dart';
import 'package:pixart_app/imports.dart';
import '../widgets/image_picker.dart';
import '../../../../features/tools/data/model/tools.dart';
import 'image_result_screen.dart';

class ToolDetailScreen extends StatelessWidget {
  final Tool tool;
  ToolDetailScreen({super.key, required this.tool}) {
    ToolsController.find.selectedTool = tool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: PrimaryBackButton(), title: Text("Pixart Apps")),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 100.sp),
              child: SizedBox(
                height: 500.sp,
                width: double.infinity,
                child: tool.prompt == null
                    ? ImageAnimation(beforeImage: tool.beforeImage, afterImage: tool.afterImage)
                    : PrimaryNetworkImage(url: tool.beforeImage, fit: BoxFit.cover),
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
                  Text(tool.name.tr, style: context.font18.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.sp),
                  Text(tool.description.tr, style: context.font14.copyWith(color: context.theme.hintColor)),
                  SizedBox(height: 24.sp),
                  PrimaryButton(
                    text: 'Try Now!',
                    onPressed: () => ToolImagePicker.show(onImagePicked: _handleApiCall),
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
    ToolResult? response;
    response = await ToolsController.find.generateImage(tool, image);
    if (response != null) {
      Get.back();
      launchScreen(ToolResultScreen(response: response));
    }
  }
}

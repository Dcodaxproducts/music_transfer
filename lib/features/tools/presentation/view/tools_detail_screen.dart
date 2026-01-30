import 'package:flutter/services.dart';
import 'package:pixart_app/core/theme/dark_theme.dart';
import 'package:pixart_app/features/profile/presentation/controller/profile_controller.dart';
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
    return Theme(
      data: dark,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: backgroundColorDark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          appBar: AppBar(leading: PrimaryBackButton(), title: Text("Pixart Apps")),
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 132.sp),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: tool.prompt == null
                        ? ImageAnimation(beforeImage: tool.beforeImage, afterImage: tool.afterImage)
                        : PrimaryNetworkImage(url: tool.beforeImage, fit: BoxFit.cover),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColorDark.withOpacity(0),
                        backgroundColorDark.withOpacity(0.1),
                        backgroundColorDark.withOpacity(0.7),
                        backgroundColorDark,
                      ],
                      stops: const [0.0, 0.25, 0.45, 0.55],
                    ),
                  ),
                  child: Padding(
                    padding: AppPadding.padding16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              tool.name.tr,
                              style: context.font18.copyWith(
                                fontWeight: FontWeight.w600,
                                color: textColorDark,
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            if (tool.premium)
                              CircleAvatar(
                                backgroundColor: primaryLight.withOpacity(0.9),
                                radius: 11.sp,
                                child: Icon(Iconsax.crown, size: 12.sp, color: Colors.white),
                              ),
                          ],
                        ),
                        SizedBox(height: 8.sp),
                        Text(tool.description.tr, style: context.font14.copyWith(color: hintColorDark)),
                        SizedBox(height: 24.sp),
                        ElevatedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Try it now',
                                style: context.font14.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: AppPadding.horizontal(6),
                                child: Image.asset(
                                  Images.sparkle,
                                  width: 16.sp,
                                  height: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${tool.credits}',
                                style: context.font14.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => ToolImagePicker.show(onImagePicked: _handleApiCall, tool: tool),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleApiCall(XFile image) async {
    ToolResult? response;
    response = await ToolsController.find.generateImage(tool, image);
    if (response != null) {
      Get.back();
      launchScreen(ToolResultScreen(response: response));
      ProfileController.find.updateProfile(); // update profile to refresh credits
    }
  }
}

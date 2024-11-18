import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/home/home.dart';
import '../../../common/primary_button.dart';
import '../../../common/snackbar.dart';
import '../../../controller/ads_controller.dart';
import '../../../controller/settings_controller.dart';
import '../../../helper/navigation.dart';
import 'widgets/model_info_widget.dart';
import 'widgets/prompt_image.dart';
import 'widgets/prompt_option.dart';

class PromptDetailScreen extends StatelessWidget {
  final PromptResponse response;
  PromptDetailScreen({super.key, required this.response}) {
    ImageGenerationController.find.promptResponse = response;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenerationController>(
      builder: (controller) {
        final result = controller.promptResponse;
        return Scaffold(
          body: Visibility(
            visible: result != null,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const PromptImageWidget(),
                Padding(
                  padding: pagePadding,
                  child: Column(
                    children: [
                      const ModelInfoWidget(),
                      const PromptOptionWidget(),
                      Padding(
                        padding: EdgeInsets.only(top: 32.sp, bottom: 16.sp),
                        child: SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            gradient: true,
                            text: 'recreate'.tr,
                            icon: Icon(
                              Iconsax.magicpen,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                            textColor: Colors.white,
                            onPressed: () {
                              SettingsController.find.promptController.text =
                                  result?.meta.prompt ?? '';
                              Get.bottomSheet(
                                Container(
                                  margin: EdgeInsets.only(top: 200.sp),
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.sp),
                                    ),
                                  ),
                                  child: HomeScreen(
                                    onRegenerate: _handleTap,
                                  ),
                                ),
                                isScrollControlled: true,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Visibility(
            visible: result != null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 64.sp,
                child: AdsController.find.showModelScreenAd(),
              ),
            ),
          ),
        );
      },
    );
  }

  _handleTap() {
    final settings = SettingsController.find;
    final text = settings.promptController.text;

    if (settings.promptController.text.isEmpty) {
      showToast('please_enter_prompt'.tr);
    } else if (settings.hasOffensiveWords) {
      showToast('please_remove_offensive_words'.tr);
    } else {
      _generateImage(text);
    }
  }

  _generateImage(String text) {
    ImageGenerationController.find
        .generateImages(
      text,
      seed: ImageGenerationController.find.promptResponse?.meta.seed,
    )
        .then(
      (response) {
        if (response != null) {
          launchScreen(PromptDetailScreen(response: response), replace: true);
        }
      },
    );
  }
}

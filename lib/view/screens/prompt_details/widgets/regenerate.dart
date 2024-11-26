import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/view/screens/prompt_details/prompt_details.dart';
import '../../../../common/snackbar.dart';
import '../../../../controller/image_generation_controller.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../data/model/response/models_lab_response.dart';
import '../../../../helper/navigation.dart';
import '../../../base/rate_us_sheet.dart';
import '../../home/home.dart';

class RegenerateButton extends StatelessWidget {
  final PromptResponse response;
  const RegenerateButton({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Padding(
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
                  response.meta.prompt;
              Get.bottomSheet(
                Container(
                  margin: EdgeInsets.only(top: 200.sp),
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
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
        .generateImages(text, seed: response.meta.seed)
        .then(
      (response) {
        if (response != null) {
          pop();
          launchScreen(PromptDetailScreen(response: response), replace: true);
          Future.delayed(const Duration(seconds: 2), () {
            showConditionalRateUsDialog();
          });
        }
      },
    );
  }
}

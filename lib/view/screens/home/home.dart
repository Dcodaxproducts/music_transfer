import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/home/widgets/models_view.dart';
import '../../../common/snackbar.dart';
import '../../../controller/image_generation_controller.dart';
import '../../../helper/navigation.dart';
import '../prompt_details/prompt_details.dart';
import 'widgets/history_view.dart';
import 'widgets/prompt_options.dart';
import 'widgets/prompt_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function()? onRegenerate;
  const HomeScreen({super.key, this.onRegenerate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (con) {
        return ListView(
          padding: pagePadding.copyWith(top: 5.sp),
          children: [
            PromptWidget(con: con),
            const ModelsView(),
            const PromptSettingsWidget(),
            Padding(
              padding: EdgeInsets.only(top: 32.sp),
              child: PrimaryButton(
                text: (widget.onRegenerate != null ? 'recreate' : 'create').tr,
                icon: Icon(
                  Iconsax.magicpen,
                  size: 18.sp,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                color: Theme.of(context).textTheme.bodyLarge?.color,
                textColor: Theme.of(context).scaffoldBackgroundColor,
                onPressed: _handleTap,
              ),
            ),
            if (widget.onRegenerate == null) ...[
              const HistoryView(),
              SizedBox(height: 80.sp),
            ]
          ],
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
    ImageGenerationController.find.generateImages(text).then(
      (response) {
        if (response != null) {
          launchScreen(PromptDetailScreen(response: response));
        }
      },
    );
  }
}

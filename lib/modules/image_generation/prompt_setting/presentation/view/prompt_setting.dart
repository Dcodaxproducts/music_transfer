import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/core/widgets/gradient_scaffold.dart';
import 'package:matrix_ai/modules/image_generation/aspect_ratio/data/model/aspect_ratio.dart';
import 'package:matrix_ai/core/helper/navigation.dart';
import 'package:matrix_ai/core/utils/style.dart';
import 'package:matrix_ai/modules/image_generation/prompt_setting/presentation/view/widgets/aspect_ratio_widget.dart';
import '../../../../../features/ads/presentation/controller/ads_controller.dart';
import '../controller/settings_controller.dart';
import '../../../../../core/utils/colors.dart';
import 'widgets/cfg_widget.dart';
import 'widgets/negative_prompt_widget.dart';
import 'widgets/seed_widget.dart';

class PromptSettingScreen extends StatelessWidget {
  const PromptSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: spacingExtraLarge),
              padding: paddingDefault,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // cancel button,
                      const IconButton(
                        onPressed: pop,
                        icon: Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      Text(
                        'settings'.tr,
                        style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          SettingsController con = SettingsController.find;
                          con.configModel = con.configModel
                              .copyWith(negativePrompt: con.negativePromptController.text.trim());
                          pop();
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          'done'.tr,
                          style: bodyMedium(context).copyWith(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GetBuilder<SettingsController>(
                      builder: (con) {
                        final selectedAspectRatio =
                            aspectRatios.firstWhere((e) => e.id == con.configModel.aspectRatio).aspectRatio;
                        return ListView(
                          children: [
                            AspectRatioSelectionWidget(
                              con: con,
                              selectedAspectRatio: selectedAspectRatio,
                            ),
                            NegativePromptWidget(con: con),
                            CFGWidget(con: con),
                            SeedWidget(con: con),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AdsController.find.buildPromptSettingAd()
        ],
      ),
    );
  }
}

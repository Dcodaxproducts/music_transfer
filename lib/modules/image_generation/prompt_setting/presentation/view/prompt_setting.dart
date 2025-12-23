import 'package:pixart_app/modules/image_generation/aspect_ratio/data/model/aspect_ratio.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/view/widgets/aspect_ratio_widget.dart';
import '../../../../../features/ads/presentation/controller/ads_controller.dart';
import '../../../../../imports.dart';
import '../controller/settings_controller.dart';
import 'widgets/cfg_widget.dart';
import 'widgets/negative_prompt_widget.dart';
import 'widgets/seed_widget.dart';

class PromptSettingScreen extends StatelessWidget {
  const PromptSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 32.sp),
              padding: AppPadding.padding16,
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
                        visualDensity: VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                      ),
                      Text(
                        'settings'.tr,
                        style: context.font14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          SettingsController con = SettingsController.find;
                          con.configModel = con.configModel.copyWith(
                            negativePrompt: con.negativePromptController.text
                                .trim(),
                          );
                          pop();
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          'done'.tr,
                          style: context.font14.copyWith(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GetBuilder<SettingsController>(
                      builder: (con) {
                        final selectedAspectRatio = aspectRatios
                            .firstWhere(
                              (e) => e.id == con.configModel.aspectRatio,
                            )
                            .aspectRatio;
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
          AdsController.find.buildPromptSettingAd(),
        ],
      ),
    );
  }
}

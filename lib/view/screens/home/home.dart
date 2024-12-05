import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/controller/models_controller.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/controller/subscription_controller.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/home/widgets/models_view.dart';
import '../../../controller/generation_controller.dart';
import '../../../helper/image_generation_helper.dart';
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
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            ModelsController.find.getModels();
          },
          child: ListView(
            padding: pagePadding.copyWith(top: 5.sp),
            children: [
              PromptWidget(con: con),
              const ModelsView(),
              const PromptSettingsWidget(),
              Padding(
                padding: EdgeInsets.only(top: 32.sp),
                child: PrimaryButton(
                  text:
                      (widget.onRegenerate != null ? 'recreate' : 'create').tr,
                  icon: Icon(
                    Iconsax.magicpen,
                    size: 18.sp,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  textColor: Theme.of(context).scaffoldBackgroundColor,
                  onPressed: widget.onRegenerate ??
                      () => ImageGenerationHelper.handleTap(
                          _handleImageGeneration),
                ),
              ),
              GetBuilder<SettingsController>(
                builder: (settingCon) {
                  return GetBuilder<GenerationController>(
                    builder: (con) => Visibility(
                      visible:
                          settingCon.settingModel.freeGenerations > 0 && !isPro,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.sp),
                        child: Center(
                          child: Text(
                            "${(settingCon.settingModel.freeGenerations - GenerationController.find.dailyGenerationCount)} ${'free_generations_are_left_for_today'.tr}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (widget.onRegenerate == null) ...[
                const HistoryView(),
                SizedBox(height: 80.sp),
              ]
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImageGeneration(String text) async {
    await ImageGenerationHelper.handleImageGeneration(text,
        generateImage: _generateImage);
  }

  void _generateImage(String text, {bool showAds = true}) {
    ImageGenerationHelper.generateImage(text, showAds: showAds);
  }
}

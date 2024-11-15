import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/data/model/body/aspect_ratio.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/settings/widgets/aspect_ratio_widget.dart';
import '../../../controller/settings_controller.dart';
import '../../../utils/colors.dart';
import 'widgets/cfg_widget.dart';
import 'widgets/negative_prompt_widget.dart';
import 'widgets/seed_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32.sp),
      padding: pagePadding,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  SettingsController con = SettingsController.find;
                  con.configModel = con.configModel.copyWith(
                      negativePrompt: con.negativePromptController.text.trim());
                  pop();
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'done'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: primaryColor),
                ),
              ),
            ],
          ),
          Expanded(
            child: GetBuilder<SettingsController>(
              builder: (con) {
                final selectedAspectRatio = aspectRatios
                    .firstWhere((e) => e.id == con.configModel.aspectRatio)
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
          )
        ],
      ),
    );
  }
}

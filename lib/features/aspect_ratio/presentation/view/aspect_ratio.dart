import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/features/aspect_ratio/presentation/view/widgets/ratio_widget.dart';
import '../../../settings/presentation/controller/settings_controller.dart';
import '../../data/model/aspect_ratio.dart';
import '../../../../core/helper/navigation.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/style.dart';

class AspectRatioScreen extends StatelessWidget {
  const AspectRatioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: spacingExtraLarge),
      padding: paddingDefault,
      decoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
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
                'aspect_ratio'.tr,
                style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  SettingsController con = SettingsController.find;
                  con.configModel =
                      con.configModel.copyWith(negativePrompt: con.negativePromptController.text.trim());
                  pop();
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text('done'.tr, style: bodyMedium(context).copyWith(color: primaryColor)),
              ),
            ],
          ),
          Expanded(
            child: GetBuilder<SettingsController>(builder: (con) {
              return GridView.builder(
                itemCount: aspectRatios.length,
                padding: EdgeInsets.only(top: spacingDefault),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: spacingSmall,
                  mainAxisSpacing: spacingSmall,
                ),
                itemBuilder: (context, index) {
                  final ratio = aspectRatios[index];
                  bool selected = con.configModel.aspectRatio == ratio.id;
                  return InkWell(
                    onTap: () {
                      con.configModel = con.configModel.copyWith(aspectRatio: ratio.id);
                      pop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: paddingDefault,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected ? primaryColor : context.theme.dividerColor,
                          width: selected ? 2 : 1,
                        ),
                        borderRadius: borderRadiusDefault,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FittedBox(child: AspectRatioBox(ratio: ratio)),
                          FittedBox(
                            child: Container(
                              width: ratio.width.toDouble(),
                              height: ratio.height.toDouble(),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2), borderRadius: borderRadiusDefault),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${ratio.width} x ${ratio.height}'
                              '\n'
                              '(${ratio.aspectRatio})',
                              textAlign: TextAlign.center,
                              style: bodyMedium(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

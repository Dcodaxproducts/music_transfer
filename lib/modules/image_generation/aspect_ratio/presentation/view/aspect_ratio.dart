import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/image_generation/aspect_ratio/presentation/view/widgets/ratio_widget.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';
import '../../data/model/aspect_ratio.dart';

class AspectRatioScreen extends StatelessWidget {
  const AspectRatioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: AppPadding.padding16.copyWith(top: 48.sp),
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
                Text('aspect_ratio'.tr, style: context.font14.copyWith(fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () {
                    SettingsController con = SettingsController.find;
                    con.configModel = con.configModel.copyWith(
                      negativePrompt: con.negativePromptController.text.trim(),
                    );
                    pop();
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text('done'.tr, style: context.font14.copyWith(color: primaryColor)),
                ),
              ],
            ),
            Expanded(
              child: GetBuilder<SettingsController>(
                builder: (con) {
                  return GridView.builder(
                    itemCount: aspectRatios.length,
                    padding: EdgeInsets.only(top: 16.sp),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.sp,
                      mainAxisSpacing: 8.sp,
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
                          padding: AppPadding.padding16,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selected ? primaryColor : context.theme.dividerColor,
                              width: selected ? 2 : 1,
                            ),
                            borderRadius: AppRadius.circular16,
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
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: AppRadius.circular16,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '${ratio.width} x ${ratio.height}'
                                  '\n'
                                  '(${ratio.aspectRatio})',
                                  textAlign: TextAlign.center,
                                  style: context.font14.copyWith(
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

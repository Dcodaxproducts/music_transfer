import 'package:pixart_app/image_generation/home/presentation/controller/models_controller.dart';
import '../../../../imports.dart';
import '../../data/model/aspect_ratio.dart';

class AspectRatioSheet extends StatelessWidget {
  const AspectRatioSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.bottomSheetTheme.backgroundColor,
        borderRadius: AppRadius.top(16),
      ),
      child: Padding(
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // back button
                SizedBox(width: 24.sp),

                // title
                Text('Aspect Ratio', style: context.font16.copyWith(fontWeight: FontWeight.w600)),

                // close button
                PrimaryCloseButton(),
              ],
            ),
            SizedBox(height: 24.sp),

            Expanded(
              child: GetBuilder<ModelsController>(
                builder: (con) {
                  return GridView.builder(
                    itemCount: aspectRatios.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.sp,
                      mainAxisSpacing: 8.sp,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final ratio = aspectRatios[index];
                      bool selected = con.selectedAspectRatio.id == ratio.id;
                      return InkWell(
                        onTap: () {
                          con.selectAspectRatio(ratio);
                          Get.back();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: AppPadding.padding16,
                          decoration: BoxDecoration(
                            border: selected ? Border.all(color: primaryColor, width: 1) : null,
                            borderRadius: AppRadius.circular16,
                            color: context.theme.canvasColor,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 40.sp,
                                height: 40.sp,
                                child: FittedBox(child: AspectRatioBox(ratio: ratio)),
                              ),
                              Center(
                                child: Text(
                                  '${ratio.width} x ${ratio.height}'
                                  '\n'
                                  '(${ratio.aspectRatio})',
                                  textAlign: TextAlign.center,
                                  style: context.font12.copyWith(color: Colors.white),
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

class AspectRatioBox extends StatelessWidget {
  final AspectRatioModel ratio;
  final bool selected;
  const AspectRatioBox({super.key, required this.ratio, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ratio.width.toDouble(),
      height: ratio.height.toDouble(),
      decoration: BoxDecoration(borderRadius: AppRadius.circular8, color: context.theme.cardColor),
    );
  }
}

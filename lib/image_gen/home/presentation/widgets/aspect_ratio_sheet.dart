import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import '../../../../core/widgets/primary_bottom_sheet.dart';
import '../../../../imports.dart';
import '../../data/model/aspect_ratio.dart';

class AspectRatioSheet extends StatelessWidget {
  const AspectRatioSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryBottomSheet(
      title: 'Aspect Ratio',
      child: Expanded(
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
                        AspectRatioBox(ratio: ratio),
                        Center(
                          child: Text(
                            '${ratio.width} x ${ratio.height}'
                            '\n'
                            '(${ratio.aspectRatio})',
                            textAlign: TextAlign.center,
                            style: context.font12,
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
    );
  }
}

class AspectRatioBox extends StatelessWidget {
  final AspectRatioModel ratio;
  const AspectRatioBox({super.key, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.sp,
      child: AspectRatio(
        aspectRatio: ratio.width / ratio.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.circular8,
            border: Border.all(color: context.font12.color!),
          ),
        ),
      ),
    );
  }
}

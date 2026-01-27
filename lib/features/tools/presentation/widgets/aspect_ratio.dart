import 'package:pixart_app/features/tools/presentation/controller/tools_controller.dart';
import '../../../../core/widgets/primary_bottom_sheet.dart';
import '../../../../image_gen/home/data/model/size_preset.dart';
import '../../../../imports.dart';

class ToolAspectRatio extends StatelessWidget {
  const ToolAspectRatio({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolsController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Aspect Ratio'.tr, style: context.font14.copyWith(fontWeight: FontWeight.w600)),
            InkWell(
              onTap: AspectRatioSheet.show,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                decoration: BoxDecoration(
                  color: context.theme.canvasColor,
                  borderRadius: AppRadius.circular32,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 4.sp),
                    AspectRatioBox(ratio: controller.selectedSize, size: 14, radius: 2),
                    SizedBox(width: 8.sp),
                    Text(controller.selectedSize.aspectRatio.tr, style: context.font14),
                    SizedBox(width: 8.sp),
                    Icon(Iconsax.arrow_down_1_copy, size: 16.sp, color: context.theme.iconTheme.color),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AspectRatioSheet extends StatelessWidget {
  const AspectRatioSheet({super.key});

  AspectRatioSheet.show({super.key}) {
    Get.bottomSheet(const AspectRatioSheet());
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryBottomSheet(
      title: 'Aspect Ratio',
      child: Expanded(
        child: GetBuilder<ToolsController>(
          builder: (con) {
            if (con.selectedTool == null) {
              return SizedBox.shrink();
            }
            return GridView.builder(
              itemCount: con.selectedTool!.model!.sizes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.sp,
                mainAxisSpacing: 8.sp,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final SizePreset ratio = con.selectedTool!.model!.sizes[index];
                bool selected = con.selectedSize.id == ratio.id;
                return InkWell(
                  onTap: () {
                    con.selectedSize = ratio;
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
  final SizePreset ratio;
  final double size;
  final double radius;
  const AspectRatioBox({super.key, required this.ratio, this.size = 40, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.sp,
      child: AspectRatio(
        aspectRatio: ratio.width / ratio.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius.sp),
            border: Border.all(color: context.font12.color!),
          ),
        ),
      ),
    );
  }
}

import 'package:pixart_app/core/widgets/shimmer.dart';
import '../../../../imports.dart';
import '../controller/tools_controller.dart';
import '../widgets/tools_card.dart';
import 'category_screen.dart';

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolsController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const ToolsShimmer();
        }
        return ListView(
          padding: AppPadding.padding12,
          children: [
            for (String category in controller.categorizedTools.keys) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category.tr, style: context.font16.copyWith(fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () {
                      launchScreen(
                        CategoryScreen(tools: controller.categorizedTools[category]!, category: category),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('See All'.tr, style: context.font14.copyWith(color: context.theme.hintColor)),
                        SizedBox(width: 4.sp),
                        Icon(Iconsax.arrow_right_1_copy, size: 16.sp, color: context.theme.hintColor),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.sp),
              SizedBox(
                height: 240.sp,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categorizedTools[category]!.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.sp),
                  itemBuilder: (_, index) {
                    final tool = controller.categorizedTools[category]![index];
                    return SizedBox(
                      width: 170.sp,
                      child: ToolCard(tool: tool, showName: false),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.sp),
            ],
          ],
        );
      },
    );
  }
}

class ToolsShimmer extends StatelessWidget {
  const ToolsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppPadding.padding12,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.width > 600 ? 4 : 2,
        mainAxisSpacing: 8.sp,
        crossAxisSpacing: 8.sp,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return CustomShimmer(
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: AppRadius.circular8),
          ),
        );
      },
    );
  }
}

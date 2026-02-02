import '../../../../imports.dart';
import '../../../ads/presentation/controller/ads_controller.dart';
import '../../data/model/tools.dart';
import '../controller/tools_controller.dart';
import '../widgets/tools_card.dart';
import '../widgets/tools_shimmer.dart';
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
        return RefreshIndicator.adaptive(
          onRefresh: () => controller.getTools(refresh: true),
          child: ListView(
            padding: AppPadding.padding12,
            children: [
              if (controller.toolCategories.isNotEmpty) AdsController.find.buildAppsScreenAd(),
              for (ToolCategory category in controller.toolCategories) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category.title.tr, style: context.font16.copyWith(fontWeight: FontWeight.w500)),
                    InkWell(
                      onTap: () {
                        launchScreen(CategoryScreen(tools: category.tools, category: category.title));
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
                    itemCount: category.tools.length,
                    separatorBuilder: (_, _) => SizedBox(width: 8.sp),
                    itemBuilder: (_, index) {
                      final tool = category.tools[index];
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
          ),
        );
      },
    );
  }
}

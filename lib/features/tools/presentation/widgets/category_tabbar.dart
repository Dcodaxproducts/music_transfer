import '../../../../imports.dart';
import '../controller/tools_controller.dart';

class CategoryTabBar extends StatelessWidget {
  final ScrollController tabScrollController;
  final Function(int) onCategorySelected;

  const CategoryTabBar({super.key, required this.tabScrollController, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolsController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.only(bottom: 24.sp),
          child: SizedBox(
            height: 40.sp,
            child: ListView.separated(
              controller: tabScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: controller.toolCategories.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.sp),
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                final category = controller.toolCategories[index];
                final isSelected = controller.selectedCategoryIndex == index;
                return InkWell(
                  onTap: () => onCategorySelected(index),
                  borderRadius: AppRadius.circular32,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: AppPadding.horizontal(16),
                    decoration: BoxDecoration(
                      color: isSelected ? context.theme.cardColor : Colors.transparent,
                      borderRadius: AppRadius.circular32,
                    ),
                    child: Center(
                      child: Text(
                        category.title.tr,
                        style: context.font12.copyWith(
                          color: isSelected ? Colors.white : context.theme.hintColor,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

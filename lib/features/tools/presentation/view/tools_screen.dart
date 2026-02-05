import 'dart:async';

import '../../../../imports.dart';
import '../../../ads/presentation/controller/ads_controller.dart';
import '../../data/model/tools.dart';
import '../controller/tools_controller.dart';
import '../widgets/category_tabbar.dart';
import '../widgets/tools_card.dart';
import '../widgets/tools_shimmer.dart';
import 'category_screen.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  // ScrollControllers for syncing
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();

  // Prevent circular updates
  bool _isScrollingProgrammatically = false;

  // Debounce scroll updates
  Timer? _scrollDebounceTimer;

  // Height constants for scroll calculation
  static const double _categoryItemHeight = 270.0;
  static const double _separatorHeight = 16.0;

  @override
  void initState() {
    super.initState();
    // Sync initial scroll position after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncInitialState();
    });
  }

  @override
  void dispose() {
    _scrollDebounceTimer?.cancel();
    _categoryScrollController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _syncInitialState() {
    final controller = ToolsController.find;
    if (controller.toolCategories.isNotEmpty &&
        _categoryScrollController.hasClients &&
        controller.selectedCategoryIndex > 0) {
      _scrollToCategory(controller.selectedCategoryIndex);
    }
  }

  void _scrollToCategory(int index) {
    final controller = ToolsController.find;
    if (!_categoryScrollController.hasClients || controller.toolCategories.isEmpty) return;

    _isScrollingProgrammatically = true;

    final offset = index * (_categoryItemHeight + _separatorHeight);
    _categoryScrollController
        .animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
        .then((_) {
          _isScrollingProgrammatically = false;
        });
  }

  void _updateCategoryFromScroll(double offset) {
    final controller = ToolsController.find;
    if (_isScrollingProgrammatically || controller.toolCategories.isEmpty) return;

    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 50), () {
      final index = (offset / (_categoryItemHeight + _separatorHeight)).round().clamp(
        0,
        controller.toolCategories.length - 1,
      );

      if (controller.selectedCategoryIndex != index) {
        controller.selectedCategoryIndex = index;
        _scrollTabToSelected();
      }
    });
  }

  void _scrollTabToSelected() {
    final controller = ToolsController.find;
    if (!_tabScrollController.hasClients || controller.toolCategories.isEmpty) return;

    if (_tabScrollController.position.isScrollingNotifier.value) return;

    const estimatedTabWidth = 120.0;
    final targetOffset =
        (controller.selectedCategoryIndex * estimatedTabWidth) - (Get.width / 2) + (estimatedTabWidth / 2);

    if (_tabScrollController.position.maxScrollExtent > 0) {
      _tabScrollController.animateTo(
        targetOffset.clamp(0.0, _tabScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onCategorySelected(int index) {
    ToolsController.find.selectedCategoryIndex = index;
    _scrollToCategory(index);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolsController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const ToolsShimmer();
        }
        return RefreshIndicator.adaptive(
          onRefresh: () => controller.getTools(refresh: true),
          child: Padding(
            padding: AppPadding.padding12,
            child: Column(
              children: [
                if (controller.toolCategories.isNotEmpty) AdsController.find.buildAppsScreenAd(),
                CategoryTabBar(
                  tabScrollController: _tabScrollController,
                  onCategorySelected: _onCategorySelected,
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        _updateCategoryFromScroll(notification.metrics.pixels);
                      }
                      return false;
                    },
                    child: ListView.separated(
                      controller: _categoryScrollController,
                      itemCount: controller.toolCategories.length,
                      separatorBuilder: (_, _) => SizedBox(height: 16.sp),
                      itemBuilder: (_, index) {
                        final ToolCategory category = controller.toolCategories[index];
                        return CategoryView(category: category);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryView extends StatelessWidget {
  final ToolCategory category;
  const CategoryView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  Text('see_all'.tr, style: context.font14.copyWith(color: context.theme.hintColor)),
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
      ],
    );
  }
}

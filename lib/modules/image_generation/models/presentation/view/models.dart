import 'package:pixart_app/features/ads/presentation/controller/ads_controller.dart';
import 'package:pixart_app/modules/image_generation/models/presentation/controller/models_controller.dart';
import 'package:pixart_app/modules/image_generation/models/presentation/view/widgets/model_grid.dart';
import '../../../../../imports.dart';
import '../../data/model/model.dart';
import '../../../../../core/widgets/tab_button.dart';

class ModelsScreen extends StatefulWidget {
  const ModelsScreen({super.key});

  @override
  State<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  final PageController _pageController = PageController();
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  void _changeTab(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    currentIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelsController>(
      builder: (modelsController) {
        return ValueListenableBuilder<int>(
          valueListenable: currentIndex,
          builder: (context, index, child) {
            final List<Model> models = modelsController.models;
            final List<Model> favoriteModels = modelsController.models
                .where((model) => modelsController.favoriteModels.contains(model.id))
                .toList();
            bool canShowAd = false;
            if (index == 0 && models.isNotEmpty) {
              canShowAd = true;
            } else if (index == 1 && favoriteModels.isNotEmpty) {
              canShowAd = true;
            }
            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 32.sp),
                      padding: AppPadding.padding16,
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
                                'set_a_theme'.tr,
                                style: context.font14.copyWith(fontWeight: FontWeight.w600),
                              ),
                              TextButton(
                                onPressed: pop,
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                child: Text('done'.tr, style: context.font14.copyWith(color: primaryColor)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.sp),
                            child: DecoratedBox(
                              decoration: BoxDecoration(borderRadius: AppRadius.circular16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PrimaryTabButton(
                                      text: 'ai_models'.tr,
                                      selected: index == 0,
                                      onPressed: () => _changeTab(0),
                                      radiusLeft: 40.sp,
                                      radiusRight: 0.sp,
                                    ),
                                  ),
                                  Expanded(
                                    child: PrimaryTabButton(
                                      text: 'favorites'.tr,
                                      selected: index == 1,
                                      onPressed: () => _changeTab(1),
                                      radiusLeft: 0.sp,
                                      radiusRight: 40.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                currentIndex.value = index;
                              },
                              children: [
                                ModelsGrid(models: models),
                                ModelsGrid(models: favoriteModels),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (canShowAd) AdsController.find.buildModelScreenAd(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

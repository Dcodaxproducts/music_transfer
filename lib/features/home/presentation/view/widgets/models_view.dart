import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix_ai/features/models/presentation/controller/models_controller.dart';
import 'package:matrix_ai/features/settings/presentation/controller/settings_controller.dart';
import '../../../../models/data/model/model.dart';
import '../../../../../imports.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../../../../models/presentation/view/set_theme.dart';
import '../../../../models/presentation/view/widgets/model_grid.dart';

class ModelsView extends StatelessWidget {
  const ModelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (setting) {
        return GetBuilder<ModelsController>(
          builder: (modelsController) {
            // if models is empty
            if (modelsController.models.isEmpty) {
              return const ModelsViewShimmer();
            }

            // get popular models
            List<Model> popularModels = modelsController.models.where((model) => model.popular).toList();

            // if popular models is empty then set popular models to all models
            if (popularModels.isEmpty) {
              popularModels = modelsController.models;
            }

            // get selected model
            late Model selectedModel;
            selectedModel = setting.configModel.selectedModel ?? modelsController.models.first;

            return Column(
              children: [
                SizedBox(height: spacingDefault),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('set_a_theme'.tr, style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      ' • ( ${selectedModel.name} )',
                      style: bodySmall(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.theme.hintColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Get.bottomSheet(const SetThemeScreen(), isScrollControlled: true),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text('see_all'.tr, style: bodySmall(context)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 110.sp,
                  child: ListView.separated(
                    itemCount: popularModels.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => SizedBox(width: spacingDefault),
                    itemBuilder: (context, index) {
                      final Model model = popularModels[index];
                      final bool selected = model.id == selectedModel.id;
                      return GestureDetector(
                        onTap: () => setting.setModel(model),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 90.sp,
                                    decoration: BoxDecoration(
                                      color: context.theme.cardColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected ? primaryColor : Colors.transparent,
                                        width: 2.sp,
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(model.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: spacingSmall),
                                Text(model.name, style: bodySmall(context)),
                              ],
                            ),
                            FavoritePremiumIcon(model: model, positioned: 0),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// models view shimmer
class ModelsViewShimmer extends StatelessWidget {
  const ModelsViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: spacingSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'set_a_theme'.tr,
              style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text('see_all'.tr, style: bodySmall(context)),
            ),
          ],
        ),
        CustomShimmer(
          child: SizedBox(
            height: 110.sp,
            child: ListView.separated(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => SizedBox(width: spacingDefault),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: 90.sp,
                          decoration: BoxDecoration(color: context.theme.cardColor, shape: BoxShape.circle),
                        ),
                      ),
                      SizedBox(height: spacingSmall),
                      Container(width: 60.sp, height: 10.sp, color: context.theme.cardColor),
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}

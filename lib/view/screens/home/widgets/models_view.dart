import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/models_controller.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import '../../../../data/model/response/model.dart';
import '../../../../utils/colors.dart';
import '../../../base/shimmer.dart';
import '../../set_theme/set_theme.dart';
import '../../set_theme/widgets/model_grid.dart';

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
            List<Model> popularModels = modelsController.models
                .where((model) => model.popular)
                .toList();

            // if popular models is empty then set popular models to all models
            if (popularModels.isEmpty) {
              popularModels = modelsController.models;
            }

            // get selected model
            late Model selectedModel;
            selectedModel = setting.configModel.selectedModel ??
                modelsController.models.first;

            return Column(
              children: [
                SizedBox(height: 8.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Set a theme',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' • ( ${selectedModel.name} )',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.bottomSheet(const SetThemeScreen(),
                            isScrollControlled: true);
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        'See all',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 110.sp,
                  child: ListView.separated(
                      itemCount: popularModels.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => SizedBox(width: 16.sp),
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
                                      duration:
                                          const Duration(milliseconds: 300),
                                      width: 90.sp,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: selected
                                              ? primaryColor
                                              : Colors.transparent,
                                          width: 2.sp,
                                        ),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              model.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.sp),
                                  Text(
                                    model.name,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              FavoritePremiumIcon(model: model, positioned: 0),
                            ],
                          ),
                        );
                      }),
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
        SizedBox(height: 8.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Set a theme',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'See all',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        CustomShimmer(
          child: SizedBox(
            height: 110.sp,
            child: ListView.separated(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => SizedBox(width: 16.sp),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: 90.sp,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Container(
                        width: 60.sp,
                        height: 10.sp,
                        color: Theme.of(context).cardColor,
                      ),
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}

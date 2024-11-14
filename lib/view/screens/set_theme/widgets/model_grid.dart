import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/models_controller.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import '../../../../data/model/response/model.dart';
import '../../../../utils/colors.dart';

class ModelsGrid extends StatelessWidget {
  final List<Model> models;
  const ModelsGrid({super.key, required this.models});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (setting) {
        return GetBuilder<ModelsController>(
          builder: (modelsController) {
            return GridView.builder(
              padding: EdgeInsets.only(top: 8.sp),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.sp,
                crossAxisSpacing: 16.sp,
                childAspectRatio: 0.75,
              ),
              itemCount: models.length,
              itemBuilder: (context, index) {
                bool selected =
                    setting.configModel.selectedModel?.id == models[index].id;
                return AIModelCard(model: models[index], selected: selected);
              },
            );
          },
        );
      },
    );
  }
}

class AIModelCard extends StatelessWidget {
  final Model model;
  final bool selected;
  const AIModelCard({super.key, required this.model, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SettingsController setting = SettingsController.find;
        setting.configModel =
            setting.configModel.copyWith(selectedModel: model);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.sp),
          border: Border.all(
            color: selected ? primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    height: 120.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.sp),
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(model.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  FavoritePremiumIcon(model: model),
                  // popular text,
                  if (model.popular)
                    Positioned(
                      top: 8.sp,
                      left: 8.sp,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.sp,
                          vertical: 4.sp,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(32.sp),
                          border:
                              Border.all(color: secondaryColor, width: 1.sp),
                        ),
                        child: Text(
                          'Hot'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.sp),
                  Text(
                    model.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FavoritePremiumIcon extends StatelessWidget {
  final Model model;
  final double positioned;
  const FavoritePremiumIcon(
      {super.key, required this.model, this.positioned = 8});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: positioned.sp,
      right: positioned.sp,
      child: GestureDetector(
        onTap: () {
          if (model.premium) {
            return;
          }
          ModelsController modelsController = ModelsController.find;
          modelsController.toggleFavorite(model.id);
        },
        child: Container(
          padding: EdgeInsets.all(5.sp),
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]),
          child: Icon(
            getIcon(),
            size: 15.sp,
            color: isFavorite ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }

  IconData getIcon() {
    if (model.premium) {
      return Iconsax.crown_1;
    } else if (isFavorite) {
      return Iconsax.heart5;
    } else {
      return Iconsax.heart;
    }
  }

  bool get isFavorite {
    ModelsController modelsController = ModelsController.find;
    return modelsController.favoriteModels.contains(model.id);
  }
}

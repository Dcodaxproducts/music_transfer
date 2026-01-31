import 'package:pixart_app/features/ads/presentation/controller/ads_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import '../../../../core/widgets/primary_bottom_sheet.dart';
import '../../../../imports.dart';
import '../../data/model/model.dart';

class ModelsSheet extends StatelessWidget {
  const ModelsSheet({super.key});

  ModelsSheet.show({super.key}) {
    Get.bottomSheet(const ModelsSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryBottomSheet(
      padding: EdgeInsets.only(top: 24.sp),
      title: 'models'.tr,
      child: Expanded(
        child: GetBuilder<ModelsController>(
          builder: (controller) {
            // copy models list
            List<Model> models = [...controller.models];

            // filter models that support image if an image is attached
            if (ImageGenController.find.attachedImages.isNotEmpty) {
              models = models.where((model) => model.supportImage).toList();
            }

            // get selected model
            Model selectedModel = controller.selectedModel ?? controller.models.first;

            return ListView.separated(
              itemCount: models.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.sp),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AdsController.find.buildModelScreenAd(),
                      SettingSheetTile(model: models[index], selected: models[index].id == selectedModel.id),
                    ],
                  );
                }
                return SettingSheetTile(model: models[index], selected: models[index].id == selectedModel.id);
              },
            );
          },
        ),
      ),
    );
  }
}

class SettingSheetTile extends StatelessWidget {
  final bool selected;
  final Model model;
  const SettingSheetTile({super.key, this.selected = false, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ModelsController.find.selectModel(model);
        Get.back();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: AppPadding.padding12,
        decoration: BoxDecoration(
          color: selected ? context.theme.canvasColor : null,
          borderRadius: AppRadius.circular16,
        ),
        child: Row(
          children: [
            SizedBox(width: 4.sp),
            ClipRRect(
              borderRadius: AppRadius.circular32,
              child: SizedBox(
                width: 26.sp,
                height: 26.sp,
                child: CachedNetworkImage(imageUrl: model.image, color: context.font14.color),
              ),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8.sp,
                    children: [
                      Expanded(
                        child: Text(model.name, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                        decoration: BoxDecoration(
                          color: selected ? context.theme.cardColor : context.theme.canvasColor,
                          borderRadius: AppRadius.circular8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Images.sparkle_outline, width: 10.sp, color: context.font12.color),
                            SizedBox(width: 4.sp),
                            Text('${model.creditsPerImage}', style: context.font10),
                          ],
                        ),
                      ),
                      if (model.isPro)
                        Container(
                          width: 20.sp,
                          height: 20.sp,
                          decoration: BoxDecoration(gradient: primaryGradient, shape: BoxShape.circle),
                          child: Icon(Iconsax.crown, size: 12.sp, color: Colors.white),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.sp),
                  Text(model.description, style: context.font10.copyWith(color: context.theme.hintColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import '../../../../imports.dart';
import '../../data/model/model.dart';

class ModelsSheet extends StatelessWidget {
  const ModelsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24.sp),
      decoration: BoxDecoration(
        color: context.theme.bottomSheetTheme.backgroundColor,
        borderRadius: AppRadius.top(16),
      ),
      child: Padding(
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // back button
                SizedBox(width: 24.sp),

                // title
                Text('Models', style: context.font16.copyWith(fontWeight: FontWeight.w600)),

                // close button
                PrimaryCloseButton(),
              ],
            ),
            SizedBox(height: 24.sp),

            Expanded(
              child: GetBuilder<ModelsController>(
                builder: (controller) {
                  // get selected model
                  Model selectedModel = controller.selectedModel ?? controller.models.first;
                  return ListView.separated(
                    itemCount: controller.models.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.sp),
                    itemBuilder: (context, index) {
                      return SettingSheetTile(
                        model: controller.models[index],
                        selected: controller.models[index].id == selectedModel.id,
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
                        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 2.sp),
                        decoration: BoxDecoration(
                          color: selected ? context.theme.cardColor : context.theme.canvasColor,
                          borderRadius: AppRadius.circular4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.magic_star, size: 10.sp, color: context.font12.color),
                            SizedBox(width: 4.sp),
                            Text('${model.creditsPerImage}', style: context.font12),
                          ],
                        ),
                      ),
                      if (model.isPro)
                        Container(
                          width: 20.sp,
                          height: 20.sp,
                          decoration: BoxDecoration(gradient: primaryGradient, shape: BoxShape.circle),
                          child: Icon(Iconsax.crown5, size: 12.sp, color: Colors.white),
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

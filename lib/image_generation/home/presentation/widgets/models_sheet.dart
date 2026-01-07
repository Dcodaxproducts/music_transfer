import 'package:pixart_app/image_generation/home/presentation/controller/models_controller.dart';
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
            CircleAvatar(
              radius: 20.sp,
              backgroundImage: NetworkImage(model.image),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(model.name, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        width: 22.sp,
                        height: 22.sp,
                        decoration: BoxDecoration(gradient: primaryGradient, shape: BoxShape.circle),
                        child: Icon(Iconsax.crown5, size: 14.sp, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    model.shortDescription,
                    style: context.font10.copyWith(color: context.theme.hintColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

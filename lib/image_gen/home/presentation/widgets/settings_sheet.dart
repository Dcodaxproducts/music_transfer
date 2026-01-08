import 'package:pixart_app/image_gen/home/data/model/model.dart';

import '../../../../core/widgets/primary_bottom_sheet.dart';
import '../../../../imports.dart';
import '../../data/model/aspect_ratio.dart';
import '../controller/models_controller.dart';
import 'aspect_ratio_sheet.dart';
import 'models_sheet.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelsController>(
      builder: (controller) {
        Model? selectedModel = controller.selectedModel;
        AspectRatioModel selectedAspectRatio = controller.selectedAspectRatio;
        return PrimaryBottomSheet(
          title: 'Settings',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingSheetTile(
                title: 'Model',
                icon: Iconsax.cpu,
                valueText: selectedModel?.name ?? 'N/A',
                onPressed: () {
                  Get.bottomSheet(ModelsSheet(), isScrollControlled: true);
                },
              ),
              SettingSheetTile(
                title: 'Aspect Ratio',
                icon: Iconsax.format_square,
                valueText: selectedAspectRatio.aspectRatio,
                onPressed: () {
                  Get.bottomSheet(AspectRatioSheet());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingSheetTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool? value;
  final String valueText;
  final Function()? onPressed;
  const SettingSheetTile({
    super.key,
    required this.title,
    required this.icon,
    this.value,
    required this.valueText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.circular16,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(color: context.theme.canvasColor, borderRadius: AppRadius.circular16),
          child: Row(
            children: [
              Icon(icon, size: 24.sp, color: context.font14.color),
              SizedBox(width: 12.sp),
              Expanded(
                child: Text(title, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
              ),
              if (value != null)
                Switch(value: value!, onChanged: (_) {}, activeColor: context.theme.primaryColor)
              else
                Text(valueText, style: context.font14.copyWith(color: context.theme.hintColor)),
              SizedBox(width: 8.sp),
              Icon(Icons.keyboard_arrow_right_rounded, size: 24.sp, color: context.font14.color),
            ],
          ),
        ),
      ),
    );
  }
}

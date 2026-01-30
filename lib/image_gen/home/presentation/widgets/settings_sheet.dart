import 'package:pixart_app/image_gen/home/data/model/model.dart';
import '../../../../core/widgets/primary_bottom_sheet.dart';
import '../../../../imports.dart';
import '../../data/model/size_preset.dart';
import '../controller/models_controller.dart';
import 'aspect_ratio_sheet.dart';
import 'models_sheet.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  SettingsSheet.show({super.key}) {
    ModelsController.find.getModels();
    Get.bottomSheet(const SettingsSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelsController>(
      builder: (controller) {
        Model? selectedModel = controller.selectedModel;
        SizePreset selectedAspectRatio = controller.selectedSize;
        return PrimaryBottomSheet(
          title: "image_settings".tr,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingSheetTile(
                title: "model".tr,
                icon: Iconsax.cpu_copy,
                valueText: selectedModel?.name ?? 'N/A',
                onPressed: ModelsSheet.show,
              ),
              SettingSheetTile(
                title: "aspect_ratio".tr,
                icon: Iconsax.format_square_copy,
                valueText: selectedAspectRatio.aspectRatio,
                onPressed: AspectRatioSheet.show,
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

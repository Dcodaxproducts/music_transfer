import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import '../../../../core/widgets/share_button.dart';
import '../../../../imports.dart';
import 'delete_result_sheet.dart';
import 'info_sheet.dart';
import 'prompt_report.dart';

class BottomActions extends StatelessWidget {
  const BottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.sp,
        children: [
          ShareButton(url: ImageGenController.find.result?.output.first ?? ''),
          ActionButton(
            icon: Iconsax.info_circle,
            onPressed: () {
              Get.bottomSheet(ResultInfoSheet());
            },
          ),
          ActionButton(
            icon: Iconsax.flag,
            onPressed: () {
              Get.bottomSheet(const FeedbackSheeet());
            },
          ),
          ActionButton(
            icon: Iconsax.trash,
            onPressed: () {
              Get.bottomSheet(DeleteResultSheet(result: ImageGenController.find.result!));
            },
          ),
        ],
      ),
    );
  }
}

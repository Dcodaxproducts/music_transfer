import 'package:pixart_app/features/home/presentation/controller/image_generation_controller.dart';
import '../../../../core/widgets/action_button.dart';
import '../../../../imports.dart';
import 'delete_result_sheet.dart';
import 'info_sheet.dart';
import 'feedback_sheet.dart';

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
            icon: Iconsax.info_circle_copy,
            onPressed: () {
              Get.bottomSheet(ResultInfoSheet());
            },
          ),
          ActionButton(
            icon: Iconsax.flag_copy,
            onPressed: () {
              Get.bottomSheet(const FeedbackSheeet());
            },
          ),
          ActionButton(
            icon: Iconsax.trash_copy,
            onPressed: () {
              Get.bottomSheet(DeleteResultSheet(result: ImageGenController.find.result!));
            },
          ),
        ],
      ),
    );
  }
}

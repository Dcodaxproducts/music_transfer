import '../../../../../imports.dart';
import '../../../../core/widgets/share_button.dart';
import '../../data/model/upscale_result.dart';
import '../controller/image_upscale_controller.dart';
import 'delete_result_sheet.dart';

class UpscaleActions extends StatelessWidget {
  const UpscaleActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.sp,
        children: [
          ShareButton(url: ImageUpscaleController.find.result?.image ?? ''),

          ActionButton(
            icon: Iconsax.trash,
            onPressed: () {
              final UpscaleResult? result = ImageUpscaleController.find.result;
              if (result == null) return;
              Get.bottomSheet(DeleteUpscaleSheet(result: result));
            },
          ),
        ],
      ),
    );
  }
}

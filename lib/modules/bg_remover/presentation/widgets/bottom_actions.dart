import '../../../../../imports.dart';
import '../../../../core/widgets/share_button.dart';
import '../../data/model/bg_remover_result.dart';
import '../controller/background_remover_controller.dart';
import 'delete_result_sheet.dart';

class BgRemoverActions extends StatelessWidget {
  const BgRemoverActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.sp,
        children: [
          ShareButton(url: BgRemoverController.find.result?.image ?? ''),
          ActionButton(
            icon: Iconsax.trash,
            onPressed: () {
              final BgRemoverResult? result = BgRemoverController.find.result;
              if (result == null) return;
              Get.bottomSheet(DeleteBgRemoverSheet(result: result));
            },
          ),
        ],
      ),
    );
  }
}

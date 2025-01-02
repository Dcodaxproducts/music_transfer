import 'package:matrix_ai/controller/history_controller.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import '../../../../imports.dart';
import '../../history/history.dart';
import '../../history/widgets/hisory_list.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(builder: (historyController) {
      final List<PromptResponse> promptHistory = historyController.promptHistory;
      return Visibility(
        visible: promptHistory.isNotEmpty,
        child: Column(
          children: [
            SizedBox(height: spacingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('history'.tr, style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600)),
                // prompt settings
                TextButton(
                  onPressed: () => Get.bottomSheet(const HistoryScreen(), isScrollControlled: true),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text('see_all'.tr, style: bodyMedium(context)),
                ),
              ],
            ),
            SizedBox(
              height: 230.sp,
              child: ListView.separated(
                itemCount: promptHistory.length > 10 ? 10 : promptHistory.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: spacingDefault),
                itemBuilder: (context, index) {
                  return SizedBox(width: 170.sp, child: HistoryCard(response: promptHistory[index]));
                },
              ),
            )
          ],
        ),
      );
    });
  }
}

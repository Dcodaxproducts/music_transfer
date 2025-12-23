import 'package:pixart_app/modules/image_generation/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import '../../../../../imports.dart';
import '../../../history/presentation/view/history.dart';
import '../../../history/presentation/view/widgets/hisory_list.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      builder: (historyController) {
        final List<ImageGenerationResult> promptHistory =
            historyController.promptHistory;
        return Visibility(
          visible: promptHistory.isNotEmpty,
          child: Column(
            children: [
              SizedBox(height: 8.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'history'.tr,
                    style: context.font14.copyWith(fontWeight: FontWeight.w600),
                  ),
                  // prompt settings
                  TextButton(
                    onPressed: () => launchScreen(const HistoryScreen()),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text('see_all'.tr, style: context.font12),
                  ),
                ],
              ),
              SizedBox(
                height: 230.sp,
                child: ListView.separated(
                  itemCount: promptHistory.length > 10
                      ? 10
                      : promptHistory.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 16.sp),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 170.sp,
                      child: HistoryCard(response: promptHistory[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

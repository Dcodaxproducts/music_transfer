import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import '../../history/history.dart';
import '../../history/widgets/hisory_list.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(builder: (historyController) {
      final List<PromptResponse> promptHistory =
          historyController.promptHistory;
      promptHistory.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return Visibility(
        visible: promptHistory.isNotEmpty,
        child: Column(
          children: [
            SizedBox(height: 8.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                // prompt settings
                TextButton(
                  onPressed: () {
                    Get.bottomSheet(const HistoryScreen(),
                        isScrollControlled: true);
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 230.sp,
              child: ListView.separated(
                itemCount: promptHistory.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 16.sp),
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: 170.sp,
                      child: HistoryCard(response: promptHistory[index]));
                },
              ),
            )
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:matrix_ai/utils/style.dart';
import '../../../data/model/response/api_response.dart';
import '../../../helper/navigation.dart';
import '../../base/tab_button.dart';
import '../dashboard/widgets/glassbox_curve.dart';
import 'widgets/hisory_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  _changeTab(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: pagePadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    Text(
                      'history'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const IconButton(
                      onPressed: pop,
                      icon: Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                    ),
                  ],
                ),
                SizedBox(height: 16.sp),
                GlassBoxCurve(
                  child: Row(
                    children: [
                      Expanded(
                        child: PrimaryTabButton(
                          text: 'all'.tr,
                          selected: currentIndex == 0,
                          onPressed: () => _changeTab(0),
                          radiusLeft: 40.sp,
                          radiusRight: 0.sp,
                        ),
                      ),
                      Expanded(
                        child: PrimaryTabButton(
                          text: 'favorites'.tr,
                          selected: currentIndex == 1,
                          onPressed: () => _changeTab(1),
                          radiusLeft: 0.sp,
                          radiusRight: 40.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<HistoryController>(builder: (historyController) {
            final List<PromptResponse> promptHistory =
                historyController.promptHistory;
            final List<PromptResponse> bookmarkedHistory = historyController
                .promptHistory
                .where((e) => e.bookmarked)
                .toList();
            return Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  HistoryList(promptHistory: promptHistory),
                  HistoryList(promptHistory: bookmarkedHistory),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

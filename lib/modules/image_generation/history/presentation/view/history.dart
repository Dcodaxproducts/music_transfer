import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/modules/image_generation/history/presentation/controller/history_controller.dart';
import 'package:matrix_ai/core/utils/style.dart';
import '../../../../../features/ads/presentation/controller/ads_controller.dart';
import '../../../home/data/model/models_lab_response.dart';
import '../../../../../core/helper/navigation.dart';
import '../../../../../core/widgets/tab_button.dart';
import '../../../../../features/dashboard/presentation/view/widgets/glassbox_curve.dart';
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
    return GetBuilder<HistoryController>(builder: (historyController) {
      final List<ImageGenerationResult> promptHistory = historyController.promptHistory;
      final List<ImageGenerationResult> bookmarkedHistory =
          historyController.promptHistory.where((e) => e.bookmarked).toList();
      bool canShowAd = false;
      if (currentIndex == 0 && promptHistory.isNotEmpty) {
        canShowAd = true;
      } else if (currentIndex == 1 && bookmarkedHistory.isNotEmpty) {
        canShowAd = true;
      }
      return Container(
        margin: EdgeInsets.only(top: spacingExtraLarge),
        decoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
        child: Column(
          children: [
            Padding(
              padding: paddingDefault,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: spacingExtraLarge),
                      Text(
                        'history'.tr,
                        style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
                      ),
                      const IconButton(
                        onPressed: pop,
                        icon: Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      ),
                    ],
                  ),
                  SizedBox(height: spacingDefault),
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
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  HistoryList(promptHistory: promptHistory),
                  HistoryList(promptHistory: bookmarkedHistory, isFavorite: true),
                ],
              ),
            ),
            if (canShowAd) ...[SizedBox(height: spacingDefault), AdsController.find.buildHistoryScreenAd()],
          ],
        ),
      );
    });
  }
}

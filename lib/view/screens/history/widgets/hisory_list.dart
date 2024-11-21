import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/common/network_image.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/images.dart';
import 'package:matrix_ai/utils/style.dart';
import 'favorite_widget.dart';
import 'history_countdown_widget.dart';

class HistoryList extends StatelessWidget {
  final List<PromptResponse> promptHistory;
  const HistoryList({super.key, required this.promptHistory});

  @override
  Widget build(BuildContext context) {
    return promptHistory.isEmpty
        ? Center(
            child: Column(
              children: [
                Image.asset(Images.no_favorite, width: 200.sp),
                Text(
                  'no_favorites_yet'.tr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          )
        : GridView.builder(
            padding: pagePadding.copyWith(top: 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.sp,
              crossAxisSpacing: 16.sp,
              childAspectRatio: 0.75,
            ),
            itemCount: promptHistory.length,
            itemBuilder: (context, index) {
              return HistoryCard(response: promptHistory[index]);
            },
          );
  }
}

class HistoryCard extends StatelessWidget {
  final PromptResponse response;
  const HistoryCard({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(
      top: Radius.circular(12.sp),
    );
    return HistoryCountdownWidget(
      response: response,
      builder: (context, isCompleted, imageUrl, remainingTime) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.sp),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Show countdown timer if image is not completed
                    isCompleted
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: Theme.of(context).cardColor,
                            ),
                            child: ClipRRect(
                              borderRadius: borderRadius,
                              child: CustomNetworkImage(
                                url: imageUrl,
                                errorLoading: true,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: Colors.grey.shade300,
                            ),
                            child: Center(
                              child: Text(
                                remainingTime,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: primaryColor),
                              ),
                            ),
                          ),

                    // favorite button
                    FavoriteHistoryIcon(response: response),

                    // copy button,
                    Positioned(
                      top: 8.sp,
                      left: 8.sp,
                      child: InkWell(
                        onTap: () {
                          final setting = SettingsController.find;
                          Clipboard.setData(
                            ClipboardData(text: response.meta.prompt),
                          );
                          setting.setPromptText(response.meta.prompt);
                          setting.configModel = setting.configModel
                              .copyWith(seed: response.meta.seed);
                          setting.seedController.text =
                              response.meta.seed.toString();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.sp,
                            vertical: 4.sp,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(32.sp),
                            border:
                                Border.all(color: secondaryColor, width: 1.sp),
                          ),
                          child: Text(
                            'copy'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response.model?.name ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      response.meta.prompt,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

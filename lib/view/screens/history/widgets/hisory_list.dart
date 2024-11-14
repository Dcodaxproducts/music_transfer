import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';
import 'favorite_widget.dart';
import 'history_countdown_widget.dart';

class HistoryList extends StatelessWidget {
  final List<PromptResponse> promptHistory;
  const HistoryList({super.key, required this.promptHistory});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: pagePadding.copyWith(top: 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.sp,
        crossAxisSpacing: 16.sp,
        childAspectRatio: 0.75.sp,
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
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.sp),
                              ),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.sp),
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

                    FavoriteHistoryIcon(response: response),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response.meta.model ?? '',
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

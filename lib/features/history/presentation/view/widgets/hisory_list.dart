import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/core/widgets/network_image.dart';
import 'package:matrix_ai/features/settings/presentation/controller/settings_controller.dart';
import 'package:matrix_ai/features/home/data/model/models_lab_response.dart';
import 'package:matrix_ai/core/utils/colors.dart';
import 'package:matrix_ai/core/utils/style.dart';
import '../../../../../core/helper/navigation.dart';
import '../../../../../core/widgets/queue_countdown.dart';
import '../../../../prompt_details/prompt_details.dart';
import '../../../../models/presentation/view/widgets/model_grid.dart';
import 'favorite_widget.dart';
import 'history_countdown_widget.dart';

class HistoryList extends StatelessWidget {
  final List<PromptResponse> promptHistory;
  final bool isFavorite;
  const HistoryList({super.key, required this.promptHistory, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return promptHistory.isEmpty
        ? const NoFavoritesWidget()
        : GridView.builder(
            padding: paddingDefault.copyWith(top: 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: spacingDefault,
              crossAxisSpacing: spacingDefault,
              childAspectRatio: 0.75,
            ),
            itemCount: promptHistory.length,
            itemBuilder: (context, index) {
              return HistoryCard(response: promptHistory[index], isFavorite: isFavorite);
            },
          );
  }
}

class HistoryCard extends StatelessWidget {
  final PromptResponse response;
  final bool isFavorite;
  const HistoryCard({super.key, required this.response, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(top: Radius.circular(radiusSmall));
    return HistoryCountdownWidget(
      response: response,
      builder: (context, isCompleted, imageUrl, remainingTime, isRetrying) {
        return InkWell(
          onTap: () {
            // Navigate to prompt details screen
            launchScreen(PromptDetailScreen(response: response, favorites: isFavorite));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: borderRadiusSmall),
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
                                color: context.theme.cardColor,
                              ),
                              child: ClipRRect(
                                borderRadius: borderRadius,
                                child: CustomNetworkImage(url: imageUrl, errorLoading: true),
                              ),
                            )
                          : QueueCountdown(remainingTime: remainingTime, isRetrying: isRetrying),

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
                            setting.configModel = setting.configModel.copyWith(seed: response.meta.seed);
                            setting.seedController.text = response.meta.seed.toString();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(spacingExtraLarge),
                              border: Border.all(color: secondaryColor, width: 1.sp),
                            ),
                            child: Text(
                              'copy'.tr.toUpperCase(),
                              style: labelLarge(context).copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: paddingSmall,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        response.model?.name ?? '',
                        style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: spacingSmall),
                      Text(response.meta.prompt, maxLines: 2, style: bodySmall(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

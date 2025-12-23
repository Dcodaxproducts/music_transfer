import 'package:flutter/services.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import '../../../../../../imports.dart';
import '../../../../models/presentation/widgets/model_grid.dart';
import '../../../../preview/presentation/view/image_gen_result.dart';
import 'favorite_widget.dart';

class HistoryList extends StatelessWidget {
  final List<ImageGenerationResult> promptHistory;
  final bool isFavorite;
  const HistoryList({super.key, required this.promptHistory, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return promptHistory.isEmpty
        ? const NoFavoritesWidget()
        : GridView.builder(
            padding: AppPadding.padding16.copyWith(top: 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.sp,
              crossAxisSpacing: 16.sp,
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
  final ImageGenerationResult response;
  final bool isFavorite;
  const HistoryCard({super.key, required this.response, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    final borderRadius = AppRadius.top(8);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: AppRadius.circular8),
      child: InkWell(
        onTap: () {
          // Navigate to prompt details screen
          launchScreen(PreviewScreen(result: response, favorites: isFavorite));
        },
        borderRadius: AppRadius.circular8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: borderRadius, color: context.theme.cardColor),
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: PrimaryNetworkImage(url: response.output.first),
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
                        Clipboard.setData(ClipboardData(text: response.meta.prompt));
                        setting.setPromptText(response.meta.prompt);
                        setting.configModel = setting.configModel.copyWith(seed: response.meta.seed);
                        setting.seedController.text = response.meta.seed.toString();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(32.sp),
                          border: Border.all(color: secondaryColor, width: 1.sp),
                        ),
                        child: Text(
                          'copy'.tr.toUpperCase(),
                          style: context.font10.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPadding.padding8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(response.meta.model.name, style: context.font14.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.sp),
                  Text(response.meta.prompt, maxLines: 2, style: context.font12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

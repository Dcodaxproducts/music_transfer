import 'dart:developer';

import 'package:pixart_app/core/widgets/context_menu.dart';
import 'package:pixart_app/image_generation/home/data/model/image_generation.dart';
import 'package:pixart_app/image_generation/home/presentation/controller/image_generation_controller.dart';
import '../../../../core/helper/image_download.dart';
import '../../../../imports.dart';
import '../../../preview/presentation/view/image_gen_result.dart';
import '../../../preview/presentation/widgets/delete_result_sheet.dart';
import 'empty_history.dart';
import 'loading_card.dart';

class HistoryList extends StatelessWidget {
  final List<ImageGenerationResult> promptHistory;
  final bool isFavorite;
  const HistoryList({super.key, required this.promptHistory, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenController>(
      builder: (imageGen) {
        return promptHistory.isEmpty && imageGen.loading.isEmpty
            ? EmptyHistory()
            : GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.sp,
                  crossAxisSpacing: 8.sp,
                  childAspectRatio: 1.0,
                ),
                itemCount: promptHistory.length + imageGen.loading.length,
                itemBuilder: (context, index) {
                  if (index < imageGen.loading.length) {
                    return const LoadingCard();
                  }
                  return HistoryCard(
                    response: promptHistory[index - imageGen.loading.length],
                    isFavorite: isFavorite,
                  );
                },
              );
      },
    );
  }
}

class HistoryCard extends StatefulWidget {
  final ImageGenerationResult response;
  final bool isFavorite;
  const HistoryCard({super.key, required this.response, this.isFavorite = false});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  final ValueNotifier<bool> _isSelected = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSelected,
      builder: (context, isSelected, child) {
        log('isSelected: $isSelected');
        return GestureDetector(
          onTap: () {
            // Navigate to prompt details screen
            launchScreen(PreviewScreen(result: widget.response, favorites: widget.isFavorite));
          },
          onLongPressStart: (details) async {
            _isSelected.value = true;
            await showPrimaryContextMenu(
              details: details,
              context: context,
              items: [
                PrimaryContextMenu(text: 'Download'.tr, icon: Iconsax.export, onTap: _downloadResult),
                PrimaryContextMenu(
                  text: 'Delete'.tr,
                  icon: Iconsax.trash,
                  color: errorColor,
                  onTap: _deleteResult,
                ),
              ],
            );
            _isSelected.value = false;
          },

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: AppRadius.circular12,
              color: context.theme.cardColor,
              border: isSelected ? Border.all(color: context.font14.color!, width: 2) : null,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.circular12,
              child: Hero(
                tag: widget.response.output.first,
                child: PrimaryNetworkImage(url: widget.response.output.first),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteResult() async {
    return Get.bottomSheet(DeleteResultSheet(result: widget.response, closeScreen: false));
  }

  Future<void> _downloadResult() async {
    showLoading();
    bool success = await DownloadImage.saveToGallery(widget.response.output.first);
    dismiss();
    if (success) {
      showToast('image_download_success'.tr);
    } else {
      showToast('Failed to download image.');
    }
  }
}

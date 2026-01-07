import 'package:pixart_app/core/widgets/context_menu.dart';
import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import '../../../../core/helper/image_download.dart';
import '../../../../imports.dart';
import '../../../preview/presentation/view/image_gen_result.dart';
import '../../../preview/presentation/widgets/delete_result_sheet.dart';
import '../widgets/empty_history.dart';
import '../widgets/loading_card.dart';

class HistoryView extends StatelessWidget {
  final List<ImageGenerationResult> promptHistory;
  const HistoryView({super.key, required this.promptHistory});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        int crossAxisCount = isWide ? 4 : 2;
        return GetBuilder<ImageGenController>(
          builder: (imageGen) {
            return promptHistory.isEmpty && imageGen.loading.isEmpty
                ? EmptyHistory()
                : GridView.builder(
                    padding: AppPadding.padding4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 4.sp,
                      crossAxisSpacing: 4.sp,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: promptHistory.length + imageGen.loading.length,
                    itemBuilder: (context, index) {
                      if (index < imageGen.loading.length) {
                        return const LoadingCard();
                      }
                      return HistoryCard(response: promptHistory[index - imageGen.loading.length]);
                    },
                  );
          },
        );
      },
    );
  }
}

class HistoryCard extends StatefulWidget {
  final ImageGenerationResult response;
  const HistoryCard({super.key, required this.response});

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
        return GestureDetector(
          onTap: () {
            // Navigate to prompt details screen
            launchScreen(PreviewScreen(result: widget.response));
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

import '../../../../core/helper/image_download.dart';
import '../../../../core/widgets/context_menu.dart';
import '../../../../imports.dart';
import '../../../home/data/model/image_generation.dart';
import '../../../preview/presentation/view/image_gen_result.dart';
import '../../../preview/presentation/widgets/delete_result_sheet.dart';

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
                PrimaryContextMenu(text: 'Download'.tr, icon: Iconsax.export_copy, onTap: _downloadResult),
                PrimaryContextMenu(
                  text: 'Delete'.tr,
                  icon: Iconsax.trash_copy,
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
      showToast("failed_to_download_image".tr);
    }
  }
}

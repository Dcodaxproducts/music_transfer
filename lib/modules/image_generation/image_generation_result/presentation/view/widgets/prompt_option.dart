import 'package:flutter/services.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/models_lab_response.dart';
import '../../../../history/presentation/controller/history_controller.dart';
import '../../../../../../core/helper/image_download.dart';
import '../../../../../../imports.dart';
import '../../../../../../core/widgets/confirmation_dialog.dart';
import '../../controller/image_generation_result_controller.dart';

class PromptOptionWidget extends StatelessWidget {
  const PromptOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenerationResultController>(
      builder: (controller) {
        final result = controller.imageGenerationResult;

        return GetBuilder<HistoryController>(
          builder: (historyController) {
            bool bookmarked = false;
            for (var element in historyController.promptHistory) {
              if (element.id == result?.id) {
                bookmarked = element.bookmarked;
              }
            }
            return Container(
              margin: EdgeInsets.only(top: 16.sp),
              height: 50.sp,
              decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: AppRadius.circular16),
              child: Row(
                children: [
                  OptionButton(
                    icon: Iconsax.copy,
                    onTap: () {
                      SettingsController setting = SettingsController.find;
                      Clipboard.setData(ClipboardData(text: result!.meta.prompt));
                      setting.setPromptText(result.meta.prompt);
                      setting.configModel = setting.configModel.copyWith(seed: result.meta.seed);
                      setting.seedController.text = result.meta.seed.toString();
                    },
                  ),
                  SizedBox(width: 16.sp),
                  OptionButton(
                    icon: bookmarked ? Iconsax.heart5 : Iconsax.heart,
                    color: bookmarked ? Colors.red : null,
                    onTap: () {
                      controller.imageGenerationResult = result!.copyWith(bookmarked: !result.bookmarked);
                      HistoryController.find.toggleFavorite(result);
                    },
                  ),
                  SizedBox(width: 16.sp),
                  if (result!.output.isNotEmpty) ...[
                    OptionButton(icon: Iconsax.import, onTap: _downloadImage),
                    SizedBox(width: 16.sp),
                  ],
                  OptionButton(
                    icon: Iconsax.trash,
                    onTap: () {
                      showConfirmationDialog(
                        title: 'delete_prompt'.tr,
                        subtitle: 'delete_prompt_message'.tr,
                        actionText: 'delete'.tr,
                        onAccept: () => _deletePrompt(result),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _downloadImage() {
    DownloadImage.downloadImage(ImageGenerationResultController.find.imageUrl ?? '');
  }

  Future<void> _deletePrompt(ImageGenerationResult response) async {
    HistoryController.find.deletePrompt(response);
    pop(2);
  }
}

class OptionButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color? color;
  const OptionButton({required this.onTap, required this.icon, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circular16,
        child: Icon(icon, color: color, size: 22.sp),
      ),
    );
  }
}

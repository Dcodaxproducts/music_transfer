import 'package:flutter/services.dart';
import 'package:matrix_ai/features/home/presentation/controller/image_generation_controller.dart';
import 'package:matrix_ai/features/settings/presentation/controller/settings_controller.dart';
import 'package:matrix_ai/features/home/data/model/models_lab_response.dart';
import '../../../../history/presentation/controller/history_controller.dart';
import '../../../../../core/helper/image_download.dart';
import '../../../../../imports.dart';
import '../../../../../core/widgets/confirmation_dialog.dart';

class PromptOptionWidget extends StatelessWidget {
  const PromptOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenerationController>(builder: (controller) {
      final result = controller.promptResponse;

      return GetBuilder<HistoryController>(builder: (historyController) {
        bool bookmarked = false;
        for (var element in historyController.promptHistory) {
          if (element.id == result?.id) {
            bookmarked = element.bookmarked;
          }
        }
        return Container(
          margin: EdgeInsets.only(top: spacingDefault),
          height: 50.sp,
          decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: borderRadiusDefault),
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
              SizedBox(width: spacingDefault),
              OptionButton(
                icon: bookmarked ? Iconsax.heart5 : Iconsax.heart,
                color: bookmarked ? Colors.red : null,
                onTap: () {
                  ImageGenerationController.find.promptResponse =
                      result!.copyWith(bookmarked: !result.bookmarked);
                  HistoryController.find.toggleFavorite(result);
                },
              ),
              SizedBox(width: spacingDefault),
              if (result!.output.isNotEmpty) ...[
                OptionButton(icon: Iconsax.import, onTap: _downloadImage),
                SizedBox(width: spacingDefault),
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
      });
    });
  }

  _downloadImage() {
    DownloadImage.downloadImage(ImageGenerationController.find.imageUrl ?? '');
  }

  _deletePrompt(PromptResponse response) async {
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
        borderRadius: borderRadiusDefault,
        child: Icon(icon, color: color, size: 22.sp),
      ),
    );
  }
}

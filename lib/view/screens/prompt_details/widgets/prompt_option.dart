import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import '../../../../controller/history_controller.dart';
import '../../../../helper/image_download.dart';
import '../../../../helper/navigation.dart';
import '../../../../utils/style.dart';
import '../../../base/confirmation_dialog.dart';

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
          margin: EdgeInsets.only(top: 16.sp),
          height: 50.sp,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Row(
            children: [
              OptionButton(
                icon: Iconsax.copy,
                onTap: () {
                  SettingsController setting = SettingsController.find;
                  Clipboard.setData(ClipboardData(text: result!.meta.prompt));
                  setting.setPromptText(result.meta.prompt);
                  setting.configModel =
                      setting.configModel.copyWith(seed: result.meta.seed);
                  setting.seedController.text = result.meta.seed.toString();
                },
              ),
              SizedBox(width: 16.sp),
              OptionButton(
                icon: bookmarked ? Iconsax.heart5 : Iconsax.heart,
                color: bookmarked ? Colors.red : null,
                onTap: () {
                  ImageGenerationController.find.promptResponse =
                      result!.copyWith(bookmarked: !result.bookmarked);
                  HistoryController.find.toggleFavorite(result);
                },
              ),
              SizedBox(width: 16.sp),
              OptionButton(
                icon: Iconsax.import,
                onTap: () => _downloadImage(result!.output.first),
              ),
              SizedBox(width: 16.sp),
              OptionButton(
                icon: Iconsax.trash,
                onTap: () {
                  showConfirmationDialog(
                    title: 'delete_prompt'.tr,
                    subtitle: 'delete_prompt_message'.tr,
                    actionText: 'delete'.tr,
                    onAccept: () => _deletePrompt(result!),
                  );
                },
              ),
            ],
          ),
        );
      });
    });
  }

  _downloadImage(String url) => DownloadImage.downloadImage(url);

  _deletePrompt(PromptResponse response) async {
    HistoryController.find.deletePrompt(response);
    pop();
    pop();
  }
}

class OptionButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color? color;
  const OptionButton(
      {required this.onTap, required this.icon, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Icon(
          icon,
          color: color,
          size: 22.sp,
        ),
      ),
    );
  }
}

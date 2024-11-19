import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
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
      final bool bookmarked = result?.bookmarked ?? false;
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
                Clipboard.setData(ClipboardData(text: result!.meta.prompt));
              },
            ),
            SizedBox(width: 16.sp),
            OptionButton(
              icon: bookmarked ? Iconsax.heart5 : Iconsax.heart,
              color: bookmarked ? Colors.red : null,
              onTap: () => controller.toggleFavorite(result!),
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
  }

  _downloadImage(String url) => DownloadImage.downloadImage(url);

  _deletePrompt(PromptResponse response) async {
    pop();
    pop();
    HistoryController.find.deletePrompt(response);
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

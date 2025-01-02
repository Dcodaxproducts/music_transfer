import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/view/base/common/network_image.dart';
import 'package:matrix_ai/controller/image_upscale_controller.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/base/view_image.dart';
import '../../../../controller/background_remover_controller.dart';
import '../../../../data/model/response/tools.dart';
import '../../../../data/model/response/upscale_response.dart';
import '../../../base/queue_countdown.dart';
import 'countdown_widget.dart';

class UpscaleHistoryList extends StatelessWidget {
  final ToolModel tool;
  const UpscaleHistoryList({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageUpscaleController>(builder: (upscaleController) {
      return GetBuilder<BackgroundRemoverController>(builder: (backgroundController) {
        List<UpscaleResponse> history = [];
        if (tool.backgroundRemover != null) {
          history = backgroundController.backgroundRemovalHistory;
        } else {
          history = upscaleController.upscaleHistory;
        }
        return Visibility(
          visible: history.isNotEmpty,
          child: Padding(
            padding: paddingDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacingDefault),
                Text(
                  'Recent'.tr,
                  style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.sp),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.only(bottom: spacingDefault),
                    itemCount: history.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: spacingDefault,
                      crossAxisSpacing: spacingDefault,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      return HistoryItem(response: history[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}

class HistoryItem extends StatelessWidget {
  final UpscaleResponse response;
  const HistoryItem({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchScreen(ViewImage(response.output.first));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadiusDefault,
        ),
        child: ClipRRect(
          borderRadius: borderRadiusDefault,
          child: UpscaleImageCountdownWidget(
            response: response,
            builder: (context, isCompleted, imageUrl, remainingTime, isRetrying) {
              return isCompleted
                  ? CustomNetworkImage(url: imageUrl, errorLoading: true)
                  : QueueCountdown(remainingTime: remainingTime, isRetrying: isRetrying, padding: false);
            },
          ),
        ),
      ),
    );
  }
}

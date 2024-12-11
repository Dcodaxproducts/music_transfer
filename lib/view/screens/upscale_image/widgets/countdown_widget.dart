import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../../controller/upscale_image_queue_controller.dart';
import '../../../../data/model/response/upscale_response.dart';

class UpscaleImageCountdownWidget extends StatelessWidget {
  final UpscaleResponse response;
  final Widget Function(
    BuildContext context,
    bool isCompleted,
    String imageUrl,
    String remainingTime,
    bool isRetrying,
  ) builder;

  UpscaleImageCountdownWidget({super.key, required this.response, required this.builder}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (response.status != 'success') {
        Get.find<UpscaleImageQueueController>().addResponse(response);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the centralized controller (assuming it's already initialized elsewhere)
    final UpscaleImageQueueController controller = Get.find<UpscaleImageQueueController>();

    final imageUrl = response.output.isNotEmpty
        ? response.output[0]
        : response.futureLinks.isNotEmpty
            ? response.futureLinks.first
            : '';

    return Obx(() {
      // Get the remaining time by the response id
      Duration remainingTime = controller.remainingTimes[response.id.toString()]?.value ?? Duration.zero;

      // Check if the response is completed
      bool isCompleted = response.status == 'success' || remainingTime == Duration.zero;

      // Check if the response is retrying
      bool isRetrying = controller.retryingStatus[response.id.toString()]?.value ?? false;

      return builder(
        context,
        isCompleted,
        imageUrl,
        _formatDuration(remainingTime),
        isRetrying,
      );
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "00:00";
    }

    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

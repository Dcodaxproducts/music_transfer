import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:matrix_ai/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:get/get.dart';
import '../../controller/queue_controller.dart';

class HistoryCountdownWidget extends StatelessWidget {
  final ImageGenerationResult response;
  final Widget Function(
    BuildContext context,
    bool isCompleted,
    String imageUrl,
    String remainingTime,
    bool isRetrying,
  ) builder;

  HistoryCountdownWidget({super.key, required this.response, required this.builder}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (response.status != 'success') {
        Get.find<QueueController>().addResponse(response);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the centralized controller (assuming it's already initialized elsewhere)
    final QueueController controller = Get.find<QueueController>();

    String imageUrl = '';
    if (response.output.isNotEmpty) {
      imageUrl = response.output[0];
    } else if (response.futureLinks.isNotEmpty) {
      imageUrl = response.futureLinks.first;
    }

    return Obx(() {
      // Get the remaining time by the response id
      Duration remainingTime = controller.remainingTimes[response.id.toString()]?.value ?? Duration.zero;

      // Check if the response is completed
      bool isCompleted = response.status == 'success' || remainingTime == Duration.zero;

      // Check if the response is retrying
      bool isRetrying = controller.retryingStatus[response.id.toString()]?.value ?? false;

      return builder(context, isCompleted, imageUrl, _formatDuration(remainingTime), isRetrying);
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

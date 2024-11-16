import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/prompt_details/prompt_details.dart';
import 'package:get/get.dart';
import '../../../../controller/queue_controller.dart';

class HistoryCountdownWidget extends StatelessWidget {
  final PromptResponse response;
  final Widget Function(
    BuildContext context,
    bool isCompleted,
    String imageUrl,
    String remainingTime,
  ) builder;

  HistoryCountdownWidget(
      {super.key, required this.response, required this.builder}) {
    // Add response to controller if it needs to be tracked (avoid setState() or markNeedsBuild() called during build error)
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

    final imageUrl = response.output.isNotEmpty
        ? response.output[0]
        : response.futureLinks.first;

    return Obx(() {
      // Use the centralized controller to get the remaining time
      Duration remainingTime =
          controller.remainingTimes[response.id.toString()]?.value ??
              Duration.zero;
      bool isCompleted =
          response.status == 'success' || remainingTime == Duration.zero;

      return InkWell(
        onTap: () {
          // Navigate to prompt details screen
          launchScreen(PromptDetailScreen(response: response));
        },
        borderRadius: BorderRadius.circular(radius),
        child: builder(
          context,
          isCompleted,
          imageUrl,
          _formatDuration(remainingTime),
        ),
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

import 'dart:async';
import 'package:get/get.dart';
import '../data/model/response/models_lab_response.dart';
import 'image_generation_controller.dart';

class QueueController extends GetxController {
  var responseList = <PromptResponse>[].obs;
  var remainingTimes =
      <String, Rx<Duration>>{}.obs; // Map of IDs to remaining times
  var retryingStatus = <String, RxBool>{}.obs; // Map of IDs to retrying state
  Map<String, Timer?> timers = {}; // Map of timers

  void initializeResponse(PromptResponse response) {
    final id = response.id.toString();
    if (!remainingTimes.containsKey(id)) {
      int initialSeconds = (((response.eta ?? 0) + 5) * 2).ceil();
      DateTime etaWithBuffer =
          response.createdAt!.add(Duration(seconds: initialSeconds));
      remainingTimes[id] =
          Rx<Duration>(etaWithBuffer.difference(DateTime.now()));
      retryingStatus[id] = RxBool(false); // Initialize retrying status

      if (response.status != 'success') {
        startCountdown(response);
      }
    }
  }

  void startCountdown(PromptResponse response) {
    final id = response.id.toString();
    timers[id] = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTimes.containsKey(id)) {
        remainingTimes[id]!.value -= const Duration(seconds: 1);

        if (remainingTimes[id]!.value.isNegative ||
            remainingTimes[id]!.value == Duration.zero) {
          timers[id]?.cancel();
          retryingStatus[id]?.value = true; // Mark as retrying
          await _checkImageStatus(response);
        }
      }
    });
  }

  Future<void> _checkImageStatus(PromptResponse response) async {
    bool success =
        await ImageGenerationController.find.getQueuedImages(response);
    final id = response.id.toString();

    if (success) {
      if (remainingTimes.containsKey(id)) {
        remainingTimes[id]!.value = Duration.zero;
        retryingStatus[id]?.value = false; // Reset retrying state
        timers[id]?.cancel();
      }
    } else {
      if (remainingTimes.containsKey(id)) {
        remainingTimes[id]!.value = const Duration(seconds: 30);
        retryingStatus[id]?.value = true; // Keep retrying
      }
      startCountdown(response);
    }
  }

  void addResponse(PromptResponse response) {
    if (responseList.contains(response)) {
      return;
    }
    responseList.add(response);
    initializeResponse(response);
  }

  @override
  void onClose() {
    for (var timer in timers.values) {
      timer?.cancel();
    }
    super.onClose();
  }
}

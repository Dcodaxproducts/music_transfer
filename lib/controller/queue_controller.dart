import 'dart:async';
import 'package:get/get.dart';
import '../data/model/response/api_response.dart';
import 'image_generation_controller.dart';

class QueueController extends GetxController {
  // Reactive list of prompt responses
  var responseList = <PromptResponse>[].obs;
  var remainingTimes =
      <String, Rx<Duration>>{}.obs; // Map of IDs to remaining times
  Map<String, Timer?> timers = {}; // Map of timers

  // Method to initialize a new response item
  void initializeResponse(PromptResponse response) {
    final id = response.id.toString();
    if (!remainingTimes.containsKey(id)) {
      // Calculate initial time remaining
      int initialSeconds = (((response.eta ?? 0) + 5) * 2).ceil();
      DateTime etaWithBuffer =
          response.createdAt!.add(Duration(seconds: initialSeconds));
      remainingTimes[id] =
          Rx<Duration>(etaWithBuffer.difference(DateTime.now()));

      // Start the countdown if necessary
      if (response.status != 'success') {
        startCountdown(response);
      }
    }
  }

  // Method to start the countdown timer for a specific response
  void startCountdown(PromptResponse response) {
    final id = response.id.toString();
    timers[id] = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTimes.containsKey(id)) {
        remainingTimes[id]!.value -= const Duration(seconds: 1);

        // When time reaches 0, call the API
        if (remainingTimes[id]!.value.isNegative ||
            remainingTimes[id]!.value == Duration.zero) {
          timers[id]?.cancel();
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
        timers[id]?.cancel(); // Stop timer on success
      }
    } else {
      // If API fails, reset countdown to 30 seconds and restart
      if (remainingTimes.containsKey(id)) {
        remainingTimes[id]!.value = const Duration(seconds: 30);
      }
      startCountdown(response); // Restart countdown
    }
  }

  // Method to add a new response to the controller
  void addResponse(PromptResponse response) {
    // If the response already exists, do nothing
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

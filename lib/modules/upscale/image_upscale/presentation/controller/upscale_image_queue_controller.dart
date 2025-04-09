import 'dart:async';
import 'package:get/get.dart';
import '../../../../bg_removal/background_remover/presentation/controller/background_remover_controller.dart';
import '../../data/model/upscale_response.dart';
import 'image_upscale_controller.dart';

class UpscaleImageQueueController extends GetxController {
  var responseList = <UpscaleResponse>[].obs;
  var remainingTimes = <String, Rx<Duration>>{}.obs; // Map of IDs to remaining times
  var retryingStatus = <String, RxBool>{}.obs; // Map of IDs to retrying state
  Map<String, Timer?> timers = {}; // Map of timers

  void initializeResponse(UpscaleResponse response) {
    final id = response.id.toString();
    if (!remainingTimes.containsKey(id)) {
      int initialSeconds = (((response.eta ?? 0) + 5) * 2).ceil();
      DateTime etaWithBuffer = response.createdAt!.add(Duration(seconds: initialSeconds));
      remainingTimes[id] = Rx<Duration>(etaWithBuffer.difference(DateTime.now()));
      retryingStatus[id] = RxBool(false); // Initialize retrying status

      if (response.status != 'success') {
        startCountdown(response);
      }
    }
  }

  void startCountdown(UpscaleResponse response) {
    final id = response.id.toString();
    timers[id] = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTimes.containsKey(id)) {
        remainingTimes[id]!.value -= const Duration(seconds: 1);

        if (remainingTimes[id]!.value.isNegative || remainingTimes[id]!.value == Duration.zero) {
          timers[id]?.cancel();
          retryingStatus[id]?.value = true; // Mark as retrying
          await _checkImageStatus(response);
        }
      }
    });
  }

  Future<void> _checkImageStatus(UpscaleResponse response) async {
    bool success = false;
    if (response.isBackgroundRemover) {
      success = await BackgroundRemoverController.find.getQueuedImages(response);
    } else {
      success = await ImageUpscaleController.find.getQueuedImages(response);
    }
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

  void addResponse(UpscaleResponse response) {
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

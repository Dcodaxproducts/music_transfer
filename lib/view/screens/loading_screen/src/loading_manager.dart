import 'dart:async';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/view/screens/loading_screen/loading_screen.dart';

class LoadingManager {
  static final LoadingManager _instance = LoadingManager._internal();

  factory LoadingManager() => _instance;

  LoadingManager._internal();

  RxInt currentStep = 0.obs;
  RxDouble progress = 0.0.obs;
  RxBool showCloseButton = false.obs;
  RxBool isCompleted = false.obs; // New observable for completion state
  RxBool isQueued = false.obs; // New observable for completion state
  RxBool isError = false.obs; // New observable for error state
  List<String> loadingTexts = [];

  static void show({bool upscale = false, bool backgroundRemover = false}) {
    _instance._show(upscale: upscale, backgroundRemover: backgroundRemover);
  }

  static void dismiss() {
    _instance._dismiss();
  }

  static void updateProgress(int step) {
    _instance._updateProgress(step);
  }

  static Future<void> complete() async {
    return await _instance._complete();
  }

  static Future<void> queue() async {
    return await _instance._queue();
  }

  static Future<void> error() async {
    return await _instance._error();
  }

  void _show({bool upscale = false, bool backgroundRemover = false}) {
    loadingTexts = _getLoadingTexts(upscale, backgroundRemover);
    currentStep.value = 0;
    progress.value = 0.0;
    showCloseButton.value = false;
    isCompleted.value = false; // Reset completion state
    isError.value = false; // Reset error state

    SmartDialog.show(
      maskColor: Get.theme.scaffoldBackgroundColor,
      backType: SmartBackType.block,
      builder: (context) => const LoadingScreen(),
    );
  }

  void _dismiss() {
    SmartDialog.dismiss();
  }

  void _updateProgress(int step) {
    if (step >= 0 && step < loadingTexts.length) {
      currentStep.value = step;
      double calculatedProgress = (step / (loadingTexts.length)) * 100;
      progress.value = calculatedProgress;
    }
  }

  Future<void> _complete() async {
    progress.value = 100.0;
    currentStep.value = loadingTexts.length; // Move step index beyond last step
    isCompleted.value = true;
    isError.value = false;
    isQueued.value = false;
    await Future.delayed(const Duration(milliseconds: 1500), _dismiss);
  }

  Future<void> _error() async {
    progress.value = 100.0;
    currentStep.value = loadingTexts.length; // Move step index beyond last step
    isError.value = true;
    isCompleted.value = false;
    isQueued.value = false;
    await Future.delayed(const Duration(milliseconds: 1500), _dismiss);
  }

  Future<void> _queue() async {
    progress.value = 100.0;
    currentStep.value = loadingTexts.length; // Move step index beyond last step
    isQueued.value = true;
    isCompleted.value = false;
    isError.value = false;
    await Future.delayed(const Duration(milliseconds: 1500), _dismiss);
  }

  List<String> _getLoadingTexts(bool upscale, bool backgroundRemover) {
    if (upscale) {
      return ["uploading_image", "analyzing_image", "upscaling_image"];
    } else if (backgroundRemover) {
      return ["uploading_image", "analyzing_image", "removing_background"];
    } else {
      return ["analyzing_prompt", "creating_your_idea", "generating_image"];
    }
  }
}

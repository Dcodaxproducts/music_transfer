import 'dart:developer';

import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import 'package:matrix_ai/data/model/response/model.dart';
import 'package:matrix_ai/data/service/image_generation_service_interface.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'generation_controller.dart';

class ImageGenerationController extends GetxController implements GetxService {
  final ImageGenerationServiceInterface imageGenerationServiceInterface;
  ImageGenerationController({required this.imageGenerationServiceInterface});

  static ImageGenerationController get find => Get.find<ImageGenerationController>();

  PromptResponse? _promptResponse;

  PromptResponse? get promptResponse => _promptResponse;

  set promptResponse(PromptResponse? value) {
    _promptResponse = value;
    Future.delayed(const Duration(milliseconds: 10), () => update());
  }

  Future<PromptResponse?> generateImages(
    String prompt, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    Model? model,
    bool showAds = true,
  }) async {
    seed = imageGenerationServiceInterface.getSeed(seed, model);
    log('seed: $seed');
    http.Response? response = await imageGenerationServiceInterface.generateImages(
      prompt,
      seed: seed,
      upscale: upscale,
      faceFix: faceFix,
      modelValue: model,
      showAds: showAds,
    );
    PromptResponse? value = await imageGenerationServiceInterface.processGenerationResponse(
        response, prompt, model, upscale, seed);

    return value;
  }

  // get queque images
  Future<bool> getQueuedImages(PromptResponse response) async {
    return await imageGenerationServiceInterface.getQueuedImages(response);
  }

  Future<void> cancelRequest() async {
    await imageGenerationServiceInterface.cancelRequest();
  }

  Future<bool> hasShowedFreeLimitDialog() async {
    return imageGenerationServiceInterface.willShowFreeLimitDialog(
      SettingsController.find.settingModel.freeGenerations,
      GenerationController.find.dailyGenerationCount,
    );
  }
}

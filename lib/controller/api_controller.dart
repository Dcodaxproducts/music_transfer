import 'dart:async';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:matrix_ai/data/model/body/config_model.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/data/service/image_generation_service_interface.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';
import 'package:http/http.dart' as http;

class ImageGenerationController extends GetxController implements GetxService {
  final ImageGenerationServiceInterface imageGenerationServiceInterface;
  ImageGenerationController({required this.imageGenerationServiceInterface});

  static ImageGenerationController get find =>
      Get.find<ImageGenerationController>();

  ConfigModel get config => SetttingsController.find.configModel;
  HistoryController get history => HistoryController.find;

  PromptResponse? _promptResponse;

  PromptResponse? get promptResponse => _promptResponse;

  set promptResponse(PromptResponse? value) {
    _promptResponse = value;
    update();
  }

  Future<PromptResponse?> generateImages(
    String prompt, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    String? modelId,
  }) async {
    http.Response? response =
        await imageGenerationServiceInterface.generateImages(
      prompt,
      config.negativePrompt,
      config.guidanceScale,
      seed: seed,
      upscale: upscale,
      faceFix: faceFix,
      modelId: modelId,
    );

    PromptResponse? value = imageGenerationServiceInterface
        .processGenerationResponse(response, prompt, modelId, upscale);

    return value;
  }
}

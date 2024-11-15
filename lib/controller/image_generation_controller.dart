import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/data/model/response/model.dart';
import 'package:matrix_ai/data/service/image_generation_service_interface.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ImageGenerationController extends GetxController implements GetxService {
  final ImageGenerationServiceInterface imageGenerationServiceInterface;
  ImageGenerationController({required this.imageGenerationServiceInterface});

  static ImageGenerationController get find =>
      Get.find<ImageGenerationController>();

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
    Model? model,
  }) async {
    http.Response? response =
        await imageGenerationServiceInterface.generateImages(
      prompt,
      seed: seed,
      upscale: upscale,
      faceFix: faceFix,
      modelValue: model,
    );

    PromptResponse? value = imageGenerationServiceInterface
        .processGenerationResponse(response, prompt, model, upscale, seed);

    return value;
  }

  // get queque images
  Future<bool> getQueuedImages(PromptResponse response) async {
    return await imageGenerationServiceInterface.getQueuedImages(response);
  }

  // toggle favorite
  void toggleFavorite(PromptResponse response) {
    imageGenerationServiceInterface.toggleFavorite(response);
    if (_promptResponse?.id == response.id) {
      _promptResponse = response.copyWith(bookmarked: !response.bookmarked);
      update();
    }
  }
}

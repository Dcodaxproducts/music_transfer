import 'package:http/http.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import 'package:matrix_ai/data/model/response/model.dart';
import '../model/response/api_model.dart';

abstract class ImageGenerationServiceInterface<T> {
  Future<ApiKeyModel?> getTogetherApiKey(Model? modelValue);

  Future<Response?> generateImages(
    String prompt, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    Model? modelValue,
    bool showAds = true,
    String? apiKey,
  });

  Future<PromptResponse?> processGenerationResponse(
    Response? response,
    String prompt,
    Model? model,
    bool upscale,
    int? seed,
  );

  Future<bool> getQueuedImages(PromptResponse response);

  Future<void> cancelRequest();

  Future<bool> willShowFreeLimitDialog(int freeGenerations, int dailyGenerationCount);

  int? getSeed(int? seed, Model? model);
}

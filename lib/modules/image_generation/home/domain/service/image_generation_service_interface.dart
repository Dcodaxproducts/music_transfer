import 'package:http/http.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:pixart_app/modules/image_generation/models/data/model/model.dart';
import '../../data/model/api_model.dart';

abstract class ImageGenerationServiceInterface<T> {
  Future<ApiKeyModel?> getTogetherApiKey(Model? modelValue);

  Future<Response?> generateImages(
    String prompt, {
    int? seed,
    Model? modelValue,
    bool showAds = true,
    String? apiKey,
  });

  Future<ImageGenerationResult?> processGenerationResponse(
    Response? response,
    String prompt,
    Model? model,
    int? seed,
  );

  Future<bool> getQueuedImages(ImageGenerationResult response);

  Future<void> cancelRequest();

  Future<bool> willShowFreeLimitDialog(int freeGenerations, int dailyGenerationCount);

  int? getSeed(int? seed, Model? model);
}

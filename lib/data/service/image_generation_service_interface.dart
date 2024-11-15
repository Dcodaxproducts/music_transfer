import 'package:http/http.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/data/model/response/model.dart';

abstract class ImageGenerationServiceInterface<T> {
  Future<Response?> generateImages(
    String prompt, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    Model? modelValue,
  });

  PromptResponse? processGenerationResponse(
    Response? response,
    String prompt,
    Model? model,
    bool upscale,
    int? seed,
  );

  Future<bool> getQueuedImages(PromptResponse response);

  void toggleFavorite(PromptResponse response);
}

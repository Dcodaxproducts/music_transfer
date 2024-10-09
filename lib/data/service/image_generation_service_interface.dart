import 'package:http/http.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';

abstract class ImageGenerationServiceInterface<T> {
  Future<Response?> generateImages(
    String prompt,
    String negativePrompt,
    double cfgScale, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    String? modelId,
  });

  PromptResponse? processGenerationResponse(
    Response? response,
    String prompt,
    String? modelId,
    bool upscale,
  );
}

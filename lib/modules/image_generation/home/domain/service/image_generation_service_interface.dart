import 'package:http/http.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import 'package:pixart_app/modules/image_generation/models/data/model/model.dart';

abstract class ImageGenerationService<T> {
  Future<Response?> generateImages(
    String prompt, {
    Model? modelValue,
    bool showAds = true,
    int? seed,
  });

  ImageGenerationResult? processGenerationResponse(Response? response);

  Future<void> cancelRequest();

  Future<bool> willShowFreeLimitDialog(
    int freeGenerations,
    int dailyGenerationCount,
  );
}

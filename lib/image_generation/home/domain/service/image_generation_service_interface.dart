import 'package:pixart_app/image_generation/home/data/model/image_generation.dart';
import 'package:pixart_app/image_generation/home/data/model/model.dart';
import 'package:pixart_app/imports.dart';

abstract class ImageGenService<T> {
  Future<Response?> generateImages(
    String prompt, {
    Model? modelValue,
    bool showAds = true,
    XFile? attachedImage,
  });

  ImageGenerationResult? processGenerationResponse(Response? response);

  Future<void> cancelRequest();

  Future<bool> willShowFreeLimitDialog(int freeGenerations, int dailyGenerationCount);
}

import 'package:pixart_app/features/home/data/model/image_generation.dart';
import 'package:pixart_app/features/home/data/model/model.dart';
import 'package:pixart_app/imports.dart';

abstract class ImageGenService<T> {
  Future<Response?> generateImages(String prompt, Model modelValue, {List<XFile>? images});

  ImageGenerationResult? processGenerationResponse(Response? response);

  Future<void> cancelRequest();
}

import 'dart:typed_data';
import 'package:pixart_app/image_generation/home/data/model/image_generation.dart';

abstract class HistoryRepo {
  Future<Uint8List?> downloadImage(String url);
  Future<void> savePromptResponsesInPref(List<ImageGenerationResult> prompts);
  List<ImageGenerationResult> getPromptResponsesFromPref();
}

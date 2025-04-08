import 'dart:typed_data';
import 'package:matrix_ai/features/home/data/model/models_lab_response.dart';

abstract class HistoryServiceInterface {
  Future<void> savePromptHistory(List<ImageGenerationResult> promptHistory);
  Future<void> addPrompt(List<ImageGenerationResult> currentHistory);
  Future<void> removePrompt(ImageGenerationResult prompt, List<ImageGenerationResult> currentHistory);
  Future<Uint8List?> downloadImage(String url);
  List<ImageGenerationResult> getPromptHistoryFromRepo();
  Future<void> deletePrompt(List<ImageGenerationResult> currentHistory);
  Future<void> toggleFavorite(List<ImageGenerationResult> currentHistory);
}

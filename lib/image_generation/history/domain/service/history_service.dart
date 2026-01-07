import 'dart:typed_data';
import 'package:pixart_app/image_generation/home/data/model/image_generation.dart';

abstract class HistoryService {
  Future<void> savePromptHistory(List<ImageGenerationResult> promptHistory);
  Future<void> addPrompt(List<ImageGenerationResult> currentHistory);
  Future<void> removePrompt(
    ImageGenerationResult prompt,
    List<ImageGenerationResult> currentHistory,
  );
  Future<Uint8List?> downloadImage(String url);
  List<ImageGenerationResult> getPromptHistoryFromRepo();
  Future<void> deletePrompt(List<ImageGenerationResult> currentHistory);
  Future<void> toggleFavorite(List<ImageGenerationResult> currentHistory);
}

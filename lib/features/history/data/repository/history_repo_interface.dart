import 'dart:typed_data';
import 'package:matrix_ai/features/home/data/model/models_lab_response.dart';

abstract class HistoryRepoInteraface {
  Future<Uint8List?> downloadImage(String url);
  Future<void> savePromptResponsesInPref(List<ImageGenerationResult> prompts);
  List<ImageGenerationResult> getPromptResponsesFromPref();
}

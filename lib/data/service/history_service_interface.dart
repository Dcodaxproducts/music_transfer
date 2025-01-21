import 'dart:typed_data';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';

abstract class HistoryServiceInterface {
  Future<void> savePromptHistory(List<PromptResponse> promptHistory);
  Future<void> addPrompt(List<PromptResponse> currentHistory);
  Future<void> removePrompt(PromptResponse prompt, List<PromptResponse> currentHistory);
  Future<Uint8List?> downloadImage(String url);
  List<PromptResponse> getPromptHistoryFromRepo();
  Future<void> deletePrompt(List<PromptResponse> currentHistory);
  Future<void> toggleFavorite(List<PromptResponse> currentHistory);
}

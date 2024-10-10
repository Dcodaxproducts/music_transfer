import 'dart:typed_data';
import 'package:matrix_ai/data/model/response/api_response.dart';

abstract class HistoryServiceInterface {
  Future<void> savePromptHistory(List<PromptResponse> promptHistory);
  Future<void> addPrompt(
      PromptResponse prompt, List<PromptResponse> currentHistory);
  Future<void> removePrompt(
      PromptResponse prompt, List<PromptResponse> currentHistory);
  Future<Uint8List?> downloadImage(String url);
  List<PromptResponse> getPromptHistoryFromRepo();
  Future<void> deletePrompt(
      PromptResponse response, List<PromptResponse> currentHistory);
  Future<void> toggleFavourite(
      PromptResponse response, List<PromptResponse> currentHistory);
}

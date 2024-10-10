import 'dart:typed_data';
import 'package:matrix_ai/data/model/response/api_response.dart';

abstract class HistoryRepoInteraface {
  Future<Uint8List?> downloadImage(String url);
  Future<void> savePromptResponsesInPref(List<PromptResponse> prompts);
  List<PromptResponse> getPromptResponsesFromPref();
}

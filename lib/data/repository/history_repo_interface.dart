import 'dart:typed_data';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';

abstract class HistoryRepoInteraface {
  Future<Uint8List?> downloadImage(String url);
  Future<void> savePromptResponsesInPref(List<PromptResponse> prompts);
  List<PromptResponse> getPromptResponsesFromPref();
}

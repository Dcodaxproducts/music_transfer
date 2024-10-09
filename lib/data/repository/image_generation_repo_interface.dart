import 'dart:typed_data';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:http/http.dart';

abstract class ImageGenerationRepoInterface {
  Future<Response?> generateImages({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  });

  Future<Response?> getQueueImage({required int requuestId});

  Future<Uint8List?> downloadImage(String url);

  Future<void> savePromptResponsesInPref(List<PromptResponse> prompts);

  List<PromptResponse> getPromptResponsesFromPref();
}

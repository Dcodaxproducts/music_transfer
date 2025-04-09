import 'dart:typed_data';
import 'package:matrix_ai/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:http/http.dart';

abstract class ImageGenerationRepoInterface {
  Future<Response?> generateImages({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  });

  Future<Response?> getQueueImage({required String url, required Map<String, dynamic> body});

  Future<Uint8List?> downloadImage(String url);

  Future<void> savePromptResponsesInPref(List<ImageGenerationResult> prompts);

  List<ImageGenerationResult> getPromptResponsesFromPref();

  Future<void> cancelRequest();

  Future<Response?> getTogetherApiKey();
}

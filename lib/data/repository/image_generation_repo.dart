import 'dart:convert';
import 'dart:typed_data';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client_interface.dart';
import 'image_generation_repo_interface.dart';

class ImageGenerationRepo implements ImageGenerationRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences sharedPreferences;

  ImageGenerationRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<Response?> generateImages({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  }) async =>
      await apiClient.post(url, body, headers: headers);

  @override
  Future<Response?> getQueueImage({required int requestId}) async =>
      await apiClient.post(AppConstants.QUEUE_URL, {
        "key": AppConstants.API_KEY,
        "request_id": requestId,
      });

  @override
  Future<Uint8List?> downloadImage(String url) async =>
      await apiClient.downloadImage(url);

  @override
  Future<void> savePromptResponsesInPref(List<PromptResponse> prompts) async {
    List<String> promptList =
        prompts.map((e) => jsonEncode(e.toJson())).toList();
    await sharedPreferences.setStringList('promptList', promptList);
  }

  @override
  List<PromptResponse> getPromptResponsesFromPref() {
    List<String>? promptList = sharedPreferences.getStringList('promptList');
    if (promptList != null) {
      return promptList
          .map((e) => PromptResponse.fromJson(jsonDecode(e)))
          .toList();
    }
    return [];
  }
}

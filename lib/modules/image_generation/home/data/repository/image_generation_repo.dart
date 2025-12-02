import 'dart:convert';
import 'dart:typed_data';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/api/api_client.dart';
import 'image_generation_repo_interface.dart';

class ImageGenerationRepo implements ImageGenerationRepoInterface {
  final ApiClient apiClient;
  final SharedPreferences prefs;

  ImageGenerationRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> generateImages({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  }) async => await apiClient.post(url, body, headers: headers, hideLoading: false);

  @override
  Future<Response?> getQueueImage({required String url, required Map<String, dynamic> body}) async =>
      await apiClient.post(url, body);

  @override
  Future<Uint8List?> downloadImage(String url) async => await apiClient.downloadImage(url);

  @override
  Future<void> savePromptResponsesInPref(List<ImageGenerationResult> prompts) async {
    List<String> promptList = prompts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('promptList', promptList);
  }

  @override
  List<ImageGenerationResult> getPromptResponsesFromPref() {
    List<String>? promptList = prefs.getStringList('promptList');
    if (promptList != null) {
      return promptList.map((e) => ImageGenerationResult.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }

  @override
  Future<void> cancelRequest() async {
    await apiClient.cancelRequest();
  }

  @override
  Future<Response?> getTogetherApiKey() async {
    return await apiClient.get(Endpoints.TOGETHER_API_KEY, hideLoading: false);
  }
}

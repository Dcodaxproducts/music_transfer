import 'dart:convert';
import 'dart:typed_data';
import 'package:matrix_ai/data/api/api_client.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  HistoryRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Uint8List?> downloadImage(String url) async =>
      await apiClient.downloadImage(url);

  Future<void> savePromptResponsesInPref(List<PromptResponse> prompts) async {
    List<String> promptList =
        prompts.map((e) => jsonEncode(e.toJson())).toList();
    await sharedPreferences.setStringList('promptList', promptList);
  }

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

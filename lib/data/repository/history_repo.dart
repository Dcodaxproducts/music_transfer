import 'dart:convert';
import 'dart:typed_data';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_repo_interface.dart';

class HistoryRepo implements HistoryRepoInteraface {
  final ApiClientInterface apiClient;
  final SharedPreferences sharedPreferences;
  HistoryRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<Uint8List?> downloadImage(String url) async =>
      await apiClient.downloadImage(url);

  @override
  Future<void> savePromptResponsesInPref(List<PromptResponse> prompts) async {
    List<String> promptList =
        prompts.map((e) => jsonEncode(e.toJson())).toList();
    await sharedPreferences.setStringList(
        AppConstants.PROMPT_HISTORY, promptList);
  }

  @override
  List<PromptResponse> getPromptResponsesFromPref() {
    List<String>? promptList =
        sharedPreferences.getStringList(AppConstants.PROMPT_HISTORY);
    if (promptList != null) {
      return promptList
          .map((e) => PromptResponse.fromJson(jsonDecode(e)))
          .toList();
    }
    return [];
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:matrix_ai/core/api/api_client_interface.dart';
import 'package:matrix_ai/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:matrix_ai/core/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_repo_interface.dart';

class HistoryRepo implements HistoryRepoInteraface {
  final ApiClientInterface apiClient;
  final SharedPreferences prefs;
  HistoryRepo({required this.apiClient, required this.prefs});

  @override
  Future<Uint8List?> downloadImage(String url) async => await apiClient.downloadImage(url);

  @override
  Future<void> savePromptResponsesInPref(List<ImageGenerationResult> prompts) async {
    List<String> promptList = prompts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(AppConstants.PROMPT_HISTORY, promptList);
  }

  @override
  List<ImageGenerationResult> getPromptResponsesFromPref() {
    List<String>? promptList = prefs.getStringList(AppConstants.PROMPT_HISTORY);
    if (promptList != null) {
      return promptList.map((e) => ImageGenerationResult.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }
}

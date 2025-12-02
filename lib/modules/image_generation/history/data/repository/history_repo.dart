import 'dart:convert';
import 'dart:typed_data';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../imports.dart';
import 'history_repo_interface.dart';

class HistoryRepo implements HistoryRepoInteraface {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  HistoryRepo({required this.apiClient, required this.prefs});

  @override
  Future<Uint8List?> downloadImage(String url) async => await apiClient.downloadImage(url);

  @override
  Future<void> savePromptResponsesInPref(List<ImageGenerationResult> prompts) async {
    List<String> promptList = prompts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(SharedKeys.PROMPT_HISTORY, promptList);
  }

  @override
  List<ImageGenerationResult> getPromptResponsesFromPref() {
    List<String>? promptList = prefs.getStringList(SharedKeys.PROMPT_HISTORY);
    if (promptList != null) {
      return promptList.map((e) => ImageGenerationResult.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }
}

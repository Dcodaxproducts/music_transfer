import 'dart:convert';
import 'dart:typed_data';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/image_generation/home/data/model/image_generation.dart';
import '../../../../imports.dart';
import 'history_repo.dart';

class HistoryRepoImpl implements HistoryRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  HistoryRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<Uint8List?> downloadImage(String url) async => await apiClient.downloadImage(url);

  @override
  Future<void> savePromptResponsesInPref(List<ImageGenerationResult> prompts) async {
    List<String> promptList = prompts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(SharedKeys.imageGenHistory, promptList);
  }

  @override
  List<ImageGenerationResult> getPromptResponsesFromPref() {
    List<String>? promptList = prefs.getStringList(SharedKeys.imageGenHistory);
    if (promptList != null) {
      return promptList.map((e) => ImageGenerationResult.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:matrix_ai/core/api/api_client_interface.dart';
import 'package:matrix_ai/core/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../upscale/image_upscale/data/model/upscale_response.dart';
import 'background_remover_repo_interface.dart';

class BackgroundRemoverRepo implements BackgroundRemoverRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences prefs;
  BackgroundRemoverRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> removeImageBackground({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  }) async =>
      await apiClient.post(url, body, headers: headers, hideLoading: false);

  @override
  Future<Response?> getQueueImage({required String url, required Map<String, dynamic> body}) async =>
      await apiClient.post(url, body);

  @override
  Future<Uint8List?> downloadImage(String url) async => await apiClient.downloadImage(url);

  @override
  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory) async {
    return await prefs.setStringList(
      AppConstants.BACKGROUND_REMOVER_HISTORY,
      upscaleHistory.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  List<String>? getHistoryFromPrefs() {
    return prefs.getStringList(AppConstants.BACKGROUND_REMOVER_HISTORY);
  }
}

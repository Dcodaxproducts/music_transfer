import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import '../model/response/upscale_response.dart';
import 'image_upscale_repo_interface.dart';

class ImageUpscaleRepo implements ImageUpscaleRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences prefs;
  ImageUpscaleRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> upscaleImage({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  }) async =>
      await apiClient.post(url, body, headers: headers);

  @override
  Future<Response?> getQueueImage({required String url, required Map<String, dynamic> body}) async =>
      await apiClient.post(url, body);

  @override
  Future<Uint8List?> downloadImage(String url) async => await apiClient.downloadImage(url);

  @override
  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory) async {
    return await prefs.setStringList(
      AppConstants.UPSCALE_IMAGE_HISTORY,
      upscaleHistory.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  List<String>? getHistoryFromPrefs() {
    return prefs.getStringList(AppConstants.UPSCALE_IMAGE_HISTORY);
  }
}

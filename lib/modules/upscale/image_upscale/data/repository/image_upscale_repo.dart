import 'dart:convert';
import 'dart:typed_data';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/upscale_response.dart';
import 'image_upscale_repo_interface.dart';

class ImageUpscaleRepo implements ImageUpscaleRepoInterface {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  ImageUpscaleRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> upscaleImage({
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
  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory) async {
    return await prefs.setStringList(
      SharedKeys.UPSCALE_IMAGE_HISTORY,
      upscaleHistory.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  List<String>? getHistoryFromPrefs() {
    return prefs.getStringList(SharedKeys.UPSCALE_IMAGE_HISTORY);
  }
}

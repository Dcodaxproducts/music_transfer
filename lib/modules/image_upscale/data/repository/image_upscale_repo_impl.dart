import 'dart:convert';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/imports.dart';
import '../../../../core/api/api_client_impl.dart';
import '../model/upscale_result.dart';
import 'image_upscale_repo.dart';

class ImageUpscaleRepoImpl implements ImageUpscaleRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  ImageUpscaleRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<Response?> upscaleImage(Map<String, dynamic> body, MultipartBody multipartBody) async =>
      await apiClient.postMultipart(Endpoints.upscaleImage, body, [multipartBody], hideLoading: false);

  @override
  Future<bool> saveHistoryInPrefs(List<UpscaleResult> upscaleHistory) async {
    return await prefs.setStringList(
      SharedKeys.upscaleHistory,
      upscaleHistory.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  List<String>? getHistoryFromPrefs() {
    return prefs.getStringList(SharedKeys.upscaleHistory);
  }
}

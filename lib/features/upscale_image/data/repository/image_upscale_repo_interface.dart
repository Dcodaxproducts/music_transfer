import 'dart:typed_data';
import 'package:http/http.dart';

import '../model/upscale_response.dart';

abstract class ImageUpscaleRepoInterface {
  Future<Response?> upscaleImage({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  });

  Future<Response?> getQueueImage({required String url, required Map<String, dynamic> body});

  Future<Uint8List?> downloadImage(String url);

  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory);

  List<String>? getHistoryFromPrefs();
}

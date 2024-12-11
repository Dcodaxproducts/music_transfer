import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:matrix_ai/data/model/response/upscale_response.dart';

abstract class BackgroundRemoverRepoInterface {
  Future<Response?> removeImageBackground({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  });

  Future<Response?> getQueueImage({required String url, required Map<String, dynamic> body});

  Future<Uint8List?> downloadImage(String url);

  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory);

  List<String>? getHistoryFromPrefs();
}

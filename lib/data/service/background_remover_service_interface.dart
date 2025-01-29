import 'dart:io';
import 'package:http/http.dart';
import 'package:matrix_ai/data/model/response/tools.dart';
import 'package:matrix_ai/data/model/response/upscale_response.dart';

abstract class BackgroundRemoverServiceInterface {
  Future<Response?> removeImageBackground({File? image, required ToolModel tool, String? urlImage});

  UpscaleResponse? processResponse({required Response? response, required ToolModel tool});

  Future<bool> getQueuedImages(UpscaleResponse value);

  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory);

  List<UpscaleResponse> getHistoryFromPrefs();
}

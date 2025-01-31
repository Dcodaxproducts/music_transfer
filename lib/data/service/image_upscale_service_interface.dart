import 'dart:io';
import 'package:http/http.dart';
import 'package:matrix_ai/data/model/response/tools.dart';
import '../model/response/upscale_response.dart';

abstract class ImageUpscaleServiceInterface {
  Future<Response?> upscaleImage({File? image, required ToolModel tool, String? urlImage});

  Future<UpscaleResponse?> processResponse({required Response? response, required ToolModel tool});

  Future<bool> getQueuedImages(UpscaleResponse value);

  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory);

  List<UpscaleResponse> getHistoryFromPrefs();
}

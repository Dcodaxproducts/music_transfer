import 'dart:io';
import 'package:http/http.dart';
import 'package:pixart_app/features/tools/data/model/tools.dart';
import '../../data/model/upscale_response.dart';

abstract class ImageUpscaleServiceInterface {
  Future<Response?> upscaleImage({File? image, required ToolModel tool, String? urlImage});

  Future<UpscaleResponse?> processResponse({required Response? response, required ToolModel tool});

  Future<bool> getQueuedImages(UpscaleResponse value);

  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory);

  List<UpscaleResponse> getHistoryFromPrefs();
}

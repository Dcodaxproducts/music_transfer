import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrix_ai/data/model/response/tools.dart';
import '../data/model/response/upscale_response.dart';
import '../data/service/image_upscale_service_interface.dart';

class ImageUpscaleController extends GetxController implements GetxService {
  final ImageUpscaleServiceInterface imageUpscaleService;
  ImageUpscaleController({required this.imageUpscaleService});

  static ImageUpscaleController get find => Get.find<ImageUpscaleController>();

  final List<UpscaleResponse> _upscaleHistory = [];
  List<UpscaleResponse> get upscaleHistory => _upscaleHistory;

  Future<UpscaleResponse?> upscaleImage({required File image, required ToolModel tool}) async {
    final http.Response? response = await imageUpscaleService.upscaleImage(image: image, tool: tool);

    return imageUpscaleService.processResponse(response: response, tool: tool);
  }

  // get queque images
  Future<bool> getQueuedImages(UpscaleResponse response) async {
    return await imageUpscaleService.getQueuedImages(response);
  }

  Future<bool> addUpscaleHistory(UpscaleResponse response) async {
    _upscaleHistory.add(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> removeUpscaleHistory(UpscaleResponse response) async {
    _upscaleHistory.remove(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> saveHistoryInPrefs() async {
    return await imageUpscaleService.saveHistoryInPrefs(_upscaleHistory);
  }

  Future<List<UpscaleResponse>> getHistoryFromPrefs() async {
    if (_upscaleHistory.isNotEmpty) return _upscaleHistory;
    final List<UpscaleResponse> history = imageUpscaleService.getHistoryFromPrefs();
    _upscaleHistory.clear();
    _upscaleHistory.addAll(history);
    update();
    return history;
  }
}

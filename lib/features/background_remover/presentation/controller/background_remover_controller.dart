import 'dart:io';
import 'package:get/get.dart';
import 'package:matrix_ai/features/upscale_image/data/model/upscale_response.dart';
import '../../../tools/data/model/tools.dart';
import 'package:http/http.dart' as http;
import '../../domain/service/background_remover_service_interface.dart';

class BackgroundRemoverController extends GetxController implements GetxService {
  final BackgroundRemoverServiceInterface backgroundRemoverService;
  BackgroundRemoverController({required this.backgroundRemoverService});

  static BackgroundRemoverController get find => Get.find<BackgroundRemoverController>();

  final List<UpscaleResponse> _backgroundRemovalHistory = [];
  List<UpscaleResponse> get backgroundRemovalHistory => _backgroundRemovalHistory;

  Future<UpscaleResponse?> removeImageBackground(
      {File? image, required ToolModel tool, String? urlImage}) async {
    final http.Response? response =
        await backgroundRemoverService.removeImageBackground(image: image, tool: tool, urlImage: urlImage);

    return backgroundRemoverService.processResponse(response: response, tool: tool);
  }

  // get queque images
  Future<bool> getQueuedImages(UpscaleResponse response) async {
    return await backgroundRemoverService.getQueuedImages(response);
  }

  Future<bool> addBackgroundRemovalHistory(UpscaleResponse response) async {
    _backgroundRemovalHistory.add(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> removeBackgroundRemovalHistory(UpscaleResponse response) async {
    _backgroundRemovalHistory.remove(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> saveHistoryInPrefs() async {
    return await backgroundRemoverService.saveHistoryInPrefs(_backgroundRemovalHistory);
  }

  Future<List<UpscaleResponse>> getHistoryFromPrefs() async {
    if (_backgroundRemovalHistory.isNotEmpty) return _backgroundRemovalHistory;
    final List<UpscaleResponse> history = backgroundRemoverService.getHistoryFromPrefs();
    _backgroundRemovalHistory.clear();
    _backgroundRemovalHistory.addAll(history);
    update();
    return history;
  }
}

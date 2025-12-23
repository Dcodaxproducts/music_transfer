import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../data/model/upscale_result.dart';
import '../../domain/service/image_upscale_service.dart';

class ImageUpscaleController extends GetxController implements GetxService {
  final ImageUpscaleService service;
  ImageUpscaleController({required this.service});

  static ImageUpscaleController get find => Get.find<ImageUpscaleController>();

  final List<UpscaleResult> _history = [];
  List<UpscaleResult> get history => _history;

  UpscaleResult? _result;
  UpscaleResult? get result => _result;
  set result(UpscaleResult? value) {
    _result = value;
    update();
  }

  Future<UpscaleResult?> upscaleImage(XFile image) async {
    final http.Response? response = await service.upscaleImage(image);
    return await service.processResponse(response);
  }

  Future<bool> addToHistory(UpscaleResult response) async {
    _history.add(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> removeFromHistory(UpscaleResult response) async {
    _history.remove(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> saveHistoryInPrefs() async {
    return await service.saveHistoryInPrefs(_history);
  }

  Future<List<UpscaleResult>> getHistoryFromPrefs() async {
    if (_history.isNotEmpty) return _history;
    final List<UpscaleResult> history = service.getHistoryFromPrefs();
    _history.clear();
    _history.addAll(history);
    update();
    return history;
  }
}

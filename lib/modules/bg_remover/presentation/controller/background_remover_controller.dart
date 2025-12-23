import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../data/model/bg_remover_result.dart';
import '../../domain/service/bg_remover_service.dart';

class BgRemoverController extends GetxController implements GetxService {
  final BgRemoverService service;
  BgRemoverController({required this.service});

  static BgRemoverController get find => Get.find<BgRemoverController>();

  final List<BgRemoverResult> _history = [];
  List<BgRemoverResult> get history => _history;

  BgRemoverResult? _result;
  BgRemoverResult? get result => _result;
  set result(BgRemoverResult? value) {
    _result = value;
    update();
  }

  Future<BgRemoverResult?> removeBg(XFile image) async {
    final http.Response? response = await service.removeBg(image);

    return service.processResponse(response);
  }

  Future<bool> addToHistory(BgRemoverResult response) async {
    _history.add(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> removeFromHistory(BgRemoverResult response) async {
    _history.remove(response);
    update();
    return await saveHistoryInPrefs();
  }

  Future<bool> saveHistoryInPrefs() async {
    return await service.saveHistoryInPrefs(_history);
  }

  Future<List<BgRemoverResult>> getHistoryFromPrefs() async {
    if (_history.isNotEmpty) return _history;
    final List<BgRemoverResult> history = service.getHistoryFromPrefs();
    _history.clear();
    _history.addAll(history);
    update();
    return history;
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/data/service/history_service_interface.dart';
import 'settings_controller.dart';

class HistoryController extends GetxController {
  final HistoryServiceInterface historyService;

  HistoryController({required this.historyService});

  static HistoryController get find => Get.find<HistoryController>();

  List<PromptResponse> _promptHistory = [];

  List<PromptResponse> get promptHistory => _promptHistory;

  set promptHistory(List<PromptResponse> value) {
    _promptHistory = value;
    historyService.savePromptHistory(value);
    update();
  }

  void addPrompt(PromptResponse prompt, {int? seed}) {
    // if seed is not null and _promptHistory has any item with the same seed then remove it
    if (seed != null) {
      _promptHistory.removeWhere((e) => e.meta.seed == seed);
    }
    _promptHistory.add(prompt);
    update();
    historyService.addPrompt(_promptHistory);
  }

  void removePrompt(PromptResponse prompt) {
    historyService.removePrompt(prompt, _promptHistory);
    update();
  }

  Future<Uint8List?> downloadImage(String url) async {
    return await historyService.downloadImage(url);
  }

  void initPromptHistory() {
    if (_promptHistory.isEmpty) {
      _promptHistory = historyService.getPromptHistoryFromRepo();
    }
    SettingsController.find.setPromptText(
      _promptHistory.isNotEmpty ? _promptHistory.last.meta.prompt : '',
    );
    update();
  }

  void deletePrompt(PromptResponse response) {
    historyService.deletePrompt(response, _promptHistory);
    update();
  }

  void toggleFavourite(PromptResponse response) {
    historyService.toggleFavourite(response, _promptHistory);
    update();
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
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

  PromptResponse addPrompt(PromptResponse prompt, {int? seed}) {
    // if seed is not null and _promptHistory has any item with the same seed then remove it
    if (seed != null) {
      PromptResponse? oldResponse = _promptHistory.firstWhereOrNull((e) => e.meta.seed == seed);
      if (oldResponse != null) {
        prompt = prompt.copyWith(linkedResponses: [oldResponse.id, ...oldResponse.linkedResponses ?? []]);
      }
    }

    // add prompt at the beginning of the list
    _promptHistory.insert(0, prompt);
    update();
    historyService.addPrompt(_promptHistory);
    return prompt;
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
      _promptHistory.isNotEmpty ? _promptHistory.first.meta.prompt : '',
    );
    update();
  }

  void deletePrompt(PromptResponse response) {
    _promptHistory.removeWhere((e) => e.id == response.id);
    update();
    historyService.deletePrompt(_promptHistory);
  }

  void toggleFavorite(PromptResponse response) {
    response = response.copyWith(bookmarked: !response.bookmarked);
    int index = _promptHistory.indexWhere((e) => e.id == response.id);
    _promptHistory[index] = response;
    update();
    historyService.toggleFavorite(_promptHistory);
  }

  int getInitialIndex(PromptResponse response, {bool favorites = false}) {
    final history = getFilteredHistory(favorites: favorites);
    return history.indexWhere((item) => item.id == response.id);
  }

  List<PromptResponse> getFilteredHistory({bool favorites = false}) {
    if (favorites) {
      return _promptHistory.where((e) => e.bookmarked).toList();
    }
    return _promptHistory;
  }

  PromptResponse? getResponseById(int id) {
    return _promptHistory.firstWhereOrNull((response) => response.id == id);
  }

  PromptResponse? getResponseByImageUrl(String imageUrl) {
    return _promptHistory.firstWhereOrNull((response) => response.output.contains(imageUrl));
  }
}

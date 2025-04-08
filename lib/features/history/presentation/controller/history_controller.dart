import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:matrix_ai/features/home/data/model/models_lab_response.dart';
import 'package:matrix_ai/features/history/domain/service/history_service_interface.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';

class HistoryController extends GetxController {
  final HistoryServiceInterface historyService;
  HistoryController({required this.historyService});

  static HistoryController get find => Get.find<HistoryController>();

  List<ImageGenerationResult> _promptHistory = [];
  List<ImageGenerationResult> get promptHistory => _promptHistory;

  set promptHistory(List<ImageGenerationResult> value) {
    _promptHistory = value;
    historyService.savePromptHistory(value);
    update();
  }

  ImageGenerationResult addPrompt(ImageGenerationResult prompt, {int? seed}) {
    // if seed is not null and _promptHistory has any item with the same seed then remove it
    if (seed != null) {
      ImageGenerationResult? oldResponse = _promptHistory.firstWhereOrNull((e) => e.meta.seed == seed);
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

  void removePrompt(ImageGenerationResult prompt) {
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

  void deletePrompt(ImageGenerationResult response) {
    _promptHistory.removeWhere((e) => e.id == response.id);
    update();
    historyService.deletePrompt(_promptHistory);
  }

  void toggleFavorite(ImageGenerationResult response) {
    response = response.copyWith(bookmarked: !response.bookmarked);
    int index = _promptHistory.indexWhere((e) => e.id == response.id);
    _promptHistory[index] = response;
    update();
    historyService.toggleFavorite(_promptHistory);
  }

  int getInitialIndex(ImageGenerationResult response, {bool favorites = false}) {
    final history = getFilteredHistory(favorites: favorites);
    return history.indexWhere((item) => item.id == response.id);
  }

  List<ImageGenerationResult> getFilteredHistory({bool favorites = false}) {
    if (favorites) {
      return _promptHistory.where((e) => e.bookmarked).toList();
    }
    return _promptHistory;
  }

  ImageGenerationResult? getResponseById(int id) {
    return _promptHistory.firstWhereOrNull((response) => response.id == id);
  }

  ImageGenerationResult? getResponseByImageUrl(String imageUrl) {
    return _promptHistory.firstWhereOrNull((response) => response.output.contains(imageUrl));
  }
}

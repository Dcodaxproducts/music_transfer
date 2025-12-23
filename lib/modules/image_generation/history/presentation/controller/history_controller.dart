import 'package:get/get.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import 'package:pixart_app/modules/image_generation/history/domain/service/history_service.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';

class HistoryController extends GetxController {
  final HistoryService historyService;
  HistoryController({required this.historyService});

  static HistoryController get find => Get.find<HistoryController>();

  List<ImageGenerationResult> _promptHistory = [];
  List<ImageGenerationResult> get promptHistory => _promptHistory;

  set promptHistory(List<ImageGenerationResult> value) {
    _promptHistory = value;
    historyService.savePromptHistory(value);
    update();
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

  ImageGenerationResult addPrompt(ImageGenerationResult prompt) {
    _promptHistory.insert(0, prompt);
    update();
    historyService.addPrompt(_promptHistory);
    return prompt;
  }

  void removePrompt(ImageGenerationResult prompt) {
    historyService.removePrompt(prompt, _promptHistory);
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
}

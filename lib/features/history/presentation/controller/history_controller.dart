import 'package:get/get.dart';
import 'package:pixart_app/features/home/data/model/image_generation.dart';
import 'package:pixart_app/features/history/domain/service/history_service.dart';

class HistoryController extends GetxController {
  final HistoryService historyService;
  HistoryController({required this.historyService});

  static HistoryController get find => Get.find<HistoryController>();

  List<ImageGenerationResult> _promptHistory = [];
  List<ImageGenerationResult> get promptHistory => _promptHistory;

  final List<ImageGenerationResult> _generations = [];
  List<ImageGenerationResult> get generations => _generations;

  void initPromptHistory() {
    if (_promptHistory.isEmpty) {
      _promptHistory = historyService.getPromptHistory();
    }
    update();
  }

  ImageGenerationResult addPrompt(ImageGenerationResult prompt) {
    _promptHistory.insert(0, prompt);
    _generations.insert(0, prompt);
    update();
    historyService.addPrompt(_promptHistory);
    return prompt;
  }

  void deletePrompt(ImageGenerationResult response) {
    _promptHistory.removeWhere((e) => e.id == response.id);
    _generations.removeWhere((e) => e.id == response.id);
    update();
    historyService.addPrompt(_promptHistory);
  }

  void clearHistory() {
    _promptHistory.clear();
    _generations.clear();
    update();
    historyService.addPrompt(_promptHistory);
  }
}

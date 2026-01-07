import 'package:get/get.dart';
import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';
import 'package:pixart_app/image_gen/history/domain/service/history_service.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';

class HistoryController extends GetxController {
  final HistoryService historyService;
  HistoryController({required this.historyService});

  static HistoryController get find => Get.find<HistoryController>();

  List<ImageGenerationResult> _promptHistory = [];
  List<ImageGenerationResult> get promptHistory => _promptHistory;

  void initPromptHistory() {
    if (_promptHistory.isEmpty) {
      _promptHistory = historyService.getPromptHistory();
    }
    SettingsController.find.setPromptText(_promptHistory.isNotEmpty ? _promptHistory.first.meta.prompt : '');
    update();
  }

  ImageGenerationResult addPrompt(ImageGenerationResult prompt) {
    _promptHistory.insert(0, prompt);
    update();
    historyService.addPrompt(_promptHistory);
    return prompt;
  }

  void deletePrompt(ImageGenerationResult response) {
    _promptHistory.removeWhere((e) => e.id == response.id);
    update();
    historyService.addPrompt(_promptHistory);
  }
}

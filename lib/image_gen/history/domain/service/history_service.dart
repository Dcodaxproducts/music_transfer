import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';

abstract class HistoryService {
  Future<void> addPrompt(List<ImageGenerationResult> currentHistory);
  List<ImageGenerationResult> getPromptHistory();
}

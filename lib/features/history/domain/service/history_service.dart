import 'dart:typed_data';
import 'package:matrix_ai/core/widgets/snackbar.dart';
import 'package:matrix_ai/features/home/data/model/models_lab_response.dart';
import 'package:matrix_ai/features/history/data/repository/history_repo_interface.dart';
import 'history_service_interface.dart';

class HistoryService implements HistoryServiceInterface {
  final HistoryRepoInteraface historyRepo;
  HistoryService({required this.historyRepo});

  @override
  Future<void> savePromptHistory(List<ImageGenerationResult> promptHistory) async {
    await historyRepo.savePromptResponsesInPref(promptHistory);
  }

  @override
  Future<void> addPrompt(List<ImageGenerationResult> currentHistory) async {
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<void> removePrompt(ImageGenerationResult prompt, List<ImageGenerationResult> currentHistory) async {
    currentHistory.remove(prompt);
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<Uint8List?> downloadImage(String url) {
    showLoading();
    return historyRepo.downloadImage(url);
  }

  @override
  List<ImageGenerationResult> getPromptHistoryFromRepo() {
    List<ImageGenerationResult> list = historyRepo.getPromptResponsesFromPref();
    list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    if (list.isNotEmpty) {
      list.removeWhere((e) => e.createdAt!.isBefore(DateTime.now().subtract(const Duration(days: 30))));
    }
    return list;
  }

  @override
  Future<void> deletePrompt(List<ImageGenerationResult> currentHistory) async {
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<void> toggleFavorite(List<ImageGenerationResult> currentHistory) async {
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }
}

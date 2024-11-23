import 'dart:typed_data';
import 'package:matrix_ai/common/snackbar.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import 'package:matrix_ai/data/repository/history_repo_interface.dart';
import 'history_service_interface.dart';

class HistoryService implements HistoryServiceInterface {
  final HistoryRepoInteraface historyRepo;
  HistoryService({required this.historyRepo});

  @override
  Future<void> savePromptHistory(List<PromptResponse> promptHistory) async {
    await historyRepo.savePromptResponsesInPref(promptHistory);
  }

  @override
  Future<void> addPrompt(List<PromptResponse> currentHistory) async {
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<void> removePrompt(
      PromptResponse prompt, List<PromptResponse> currentHistory) async {
    currentHistory.remove(prompt);
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<Uint8List?> downloadImage(String url) {
    showLoading();
    return historyRepo.downloadImage(url);
  }

  @override
  List<PromptResponse> getPromptHistoryFromRepo() {
    return historyRepo.getPromptResponsesFromPref();
  }

  @override
  Future<void> deletePrompt(List<PromptResponse> currentHistory) async {
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<void> toggleFavorite(List<PromptResponse> currentHistory) async {
    await historyRepo.savePromptResponsesInPref(currentHistory);
  }
}

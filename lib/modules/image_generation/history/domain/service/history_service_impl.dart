import 'dart:typed_data';
import 'package:pixart_app/core/widgets/snackbar.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import 'package:pixart_app/modules/image_generation/history/data/repository/history_repo.dart';
import 'history_service.dart';

class HistoryServiceImpl implements HistoryService {
  final HistoryRepo repo;
  HistoryServiceImpl({required this.repo});

  @override
  Future<void> savePromptHistory(
    List<ImageGenerationResult> promptHistory,
  ) async {
    await repo.savePromptResponsesInPref(promptHistory);
  }

  @override
  Future<void> addPrompt(List<ImageGenerationResult> currentHistory) async {
    await repo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<void> removePrompt(
    ImageGenerationResult prompt,
    List<ImageGenerationResult> currentHistory,
  ) async {
    currentHistory.remove(prompt);
    await repo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<Uint8List?> downloadImage(String url) {
    showLoading();
    return repo.downloadImage(url);
  }

  @override
  List<ImageGenerationResult> getPromptHistoryFromRepo() {
    List<ImageGenerationResult> list = repo.getPromptResponsesFromPref();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (list.isNotEmpty) {
      list.removeWhere(
        (e) => e.createdAt.isBefore(
          DateTime.now().subtract(const Duration(days: 30)),
        ),
      );
    }
    return list;
  }

  @override
  Future<void> deletePrompt(List<ImageGenerationResult> currentHistory) async {
    await repo.savePromptResponsesInPref(currentHistory);
  }

  @override
  Future<void> toggleFavorite(
    List<ImageGenerationResult> currentHistory,
  ) async {
    await repo.savePromptResponsesInPref(currentHistory);
  }
}

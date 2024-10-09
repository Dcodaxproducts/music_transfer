import 'dart:async';
import 'dart:typed_data';
import 'package:matrix_ai/common/snackbar.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/data/repository/history_repo.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class HistoryController extends GetxController implements GetxService {
  final HistoryRepo historyRepo;
  HistoryController({required this.historyRepo});

  static HistoryController get find => Get.find<HistoryController>();

  List<PromptResponse> _promptHistory = [];

  List<PromptResponse> get promptHistory => _promptHistory;

  set promptHistory(List<PromptResponse> value) {
    _promptHistory = value;
    historyRepo.savePromptResponsesInPref(value);
    update();
  }

  addPrompt(PromptResponse prompt) {
    _promptHistory.add(prompt);
    historyRepo.savePromptResponsesInPref(promptHistory);
    update();
  }

  removePrompt(PromptResponse prompt) {
    _promptHistory.remove(prompt);
    historyRepo.savePromptResponsesInPref(promptHistory);
    update();
  }

  Future<Uint8List?> downloadImage(String url) {
    showLoading();
    return historyRepo.downloadImage(url);
  }

  initPromptHistory() {
    if (_promptHistory.isEmpty) {
      promptHistory = historyRepo.getPromptResponsesFromPref();
    }
    SetttingsController.find.setPromptText(
      promptHistory.isNotEmpty ? promptHistory.last.meta.prompt : '',
    );
  }

  deletePrompt(PromptResponse response) {
    promptHistory.remove(response);
    historyRepo.savePromptResponsesInPref(promptHistory);
    update();
  }

  toogleFavourite(PromptResponse response) {
    int index = _promptHistory.indexWhere((e) => e.id == response.id);
    _promptHistory[index] = response;
    historyRepo.savePromptResponsesInPref(promptHistory);
    if (response.bookmarked) {
      showToast('bookmark_added'.tr, success: true);
    } else {
      showToast('bookmark_removed'.tr, success: true);
    }
    update();
  }
}

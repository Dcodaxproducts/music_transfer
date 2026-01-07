import 'dart:convert';

import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';
import 'package:pixart_app/image_gen/history/data/repository/history_repo.dart';
import 'history_service.dart';

class HistoryServiceImpl implements HistoryService {
  final HistoryRepo repo;
  HistoryServiceImpl({required this.repo});

  @override
  Future<bool> addPrompt(List<ImageGenerationResult> currentHistory) async {
    List<String> promptList = currentHistory.map((e) => jsonEncode(e.toJson())).toList();
    return await repo.saveHistory(promptList);
  }

  @override
  List<ImageGenerationResult> getPromptHistory() {
    // get from repo
    List<String>? historyStrings = repo.getHistory();

    // if null, return empty list
    if (historyStrings == null) {
      return [];
    }

    // convert to List<ImageGenerationResult>
    List<ImageGenerationResult> list = historyStrings
        .map((e) => ImageGenerationResult.fromJson(jsonDecode(e)))
        .toList();

    // sort by createdAt descending
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // remove items older than 30 days
    if (list.isNotEmpty) {
      list.removeWhere((e) => e.createdAt.isBefore(DateTime.now().subtract(const Duration(days: 30))));
    }

    // return list
    return list;
  }

 
}

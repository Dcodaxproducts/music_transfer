abstract class HistoryRepo {
  Future<bool> saveHistory(List<String> prompts);
  List<String>? getHistory();
}

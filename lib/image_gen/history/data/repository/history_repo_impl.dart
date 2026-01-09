import '../../../../imports.dart';
import 'history_repo.dart';

class HistoryRepoImpl implements HistoryRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  HistoryRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<bool> saveHistory(List<String> prompts) async {
    return await prefs.setStringList(SharedKeys.imageGenHistory, prompts);
  }

  @override
  List<String>? getHistory() {
    return prefs.getStringList(SharedKeys.imageGenHistory);
  }
}

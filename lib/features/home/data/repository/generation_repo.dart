import 'package:matrix_ai/features/home/data/repository/generation_repo_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerationRepo implements GenerationRepoInterface {
  final SharedPreferences prefs;
  GenerationRepo({required this.prefs});

  @override
  Future<int> getDailyGenerationCount(String key) async {
    return prefs.getInt(key) ?? 0;
  }

  @override
  Future<void> setDailyGenerationCount(String key, int count) async {
    await prefs.setInt(key, count);
  }
}

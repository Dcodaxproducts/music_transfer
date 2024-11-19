import 'package:matrix_ai/data/repository/generation_repo_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerationRepo implements GenerationRepoInterface {
  final SharedPreferences sharedPreferences;
  GenerationRepo({required this.sharedPreferences});

  @override
  Future<int> getDailyGenerationCount(String key) async {
    return sharedPreferences.getInt(key) ?? 0;
  }

  @override
  Future<void> setDailyGenerationCount(String key, int count) async {
    await sharedPreferences.setInt(key, count);
  }
}

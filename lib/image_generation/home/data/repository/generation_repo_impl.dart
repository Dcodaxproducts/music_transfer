import 'package:pixart_app/image_generation/home/data/repository/generation_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerationRepoImpl implements GenerationRepo {
  final SharedPreferences prefs;
  GenerationRepoImpl({required this.prefs});

  @override
  Future<int> getDailyGenerationCount(String key) async {
    return prefs.getInt(key) ?? 0;
  }

  @override
  Future<void> setDailyGenerationCount(String key, int count) async {
    await prefs.setInt(key, count);
  }
}

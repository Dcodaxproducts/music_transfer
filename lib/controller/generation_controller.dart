import 'package:matrix_ai/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class GenerationController extends GetxController {
  static GenerationController get find => Get.find<GenerationController>();

  static const String _keyPrefix = "generation_count_";
  int _dailyGenerationCount = 0;

  int get dailyGenerationCount => _dailyGenerationCount;

  Future<void> loadGenerationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = DateFormat('yyyyMMdd').format(DateTime.now());
    final key = '$_keyPrefix$dateString';
    final count = prefs.getInt(key) ?? 0;
    _dailyGenerationCount = count;
    update();
  }

  Future<void> incrementGenerationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = DateFormat('yyyyMMdd').format(DateTime.now());
    final key = '$_keyPrefix$dateString';
    int currentCount = prefs.getInt(key) ?? 0;
    currentCount++;
    await prefs.setInt(key, currentCount);
    _dailyGenerationCount = currentCount;
    update();
  }

  bool get canGenerateImage =>
      _dailyGenerationCount < AppConstants.FREE_GENERATIONS;
}

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'settings_controller.dart';

class GenerationController extends GetxController {
  static GenerationController get find => Get.put(GenerationController());

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

  bool get canGenerateImage {
    if (SettingsController.find.settingModel.freeGenerations > 0) {
      return _dailyGenerationCount <
          SettingsController.find.settingModel.freeGenerations;
    } else {
      return true;
    }
  }
}

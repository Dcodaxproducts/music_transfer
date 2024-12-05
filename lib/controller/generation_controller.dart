import 'package:get/get.dart';
import 'package:matrix_ai/data/service/generation_service.dart';

import '../utils/app_constants.dart';

class GenerationController extends GetxController {
  final GenerationServiceInterface generationServiceInterface;
  GenerationController({required this.generationServiceInterface});

  static GenerationController get find => Get.find<GenerationController>();

  int _dailyGenerationCount = 0;
  int get dailyGenerationCount => _dailyGenerationCount;

  Future<void> initialize() async {
    _dailyGenerationCount =
        await generationServiceInterface.loadDailyGenerationCount();
    update();
  }

  Future<void> incrementGenerationCount() async {
    await generationServiceInterface.incrementDailyGenerationCount();
    _dailyGenerationCount++;
    update();
  }

  Future<void> resetGenerationCount() async {
    await generationServiceInterface.resetDailyGenerationCount();
    _dailyGenerationCount = 0;
    update();
  }

  bool get proUserLimitExceeded =>
      _dailyGenerationCount >= AppConstants.PRO_USER_DAILY_LIMIT;
}

import 'package:intl/intl.dart';
import 'package:matrix_ai/controller/generation_controller.dart';
import 'package:matrix_ai/data/repository/generation_repo_interface.dart';
import 'package:matrix_ai/data/service/generation_service.dart';
import '../../controller/settings_controller.dart';

class GenerationService implements GenerationServiceInterface {
  final GenerationRepoInterface generationRepoInterface;
  GenerationService({required this.generationRepoInterface});
  static const String _keyPrefix = "generation_count_";

  String _generateKey() {
    final dateString = DateFormat('yyyyMMdd').format(DateTime.now());
    return '$_keyPrefix$dateString';
  }

  @override
  Future<int> loadDailyGenerationCount() async {
    final key = _generateKey();
    return await generationRepoInterface.getDailyGenerationCount(key);
  }

  @override
  Future<void> incrementDailyGenerationCount() async {
    final key = _generateKey();
    final currentCount =
        await generationRepoInterface.getDailyGenerationCount(key);
    await generationRepoInterface.setDailyGenerationCount(
        key, currentCount + 1);
  }

  @override
  bool canGenerateImage() {
    if (SettingsController.find.settingModel.freeGenerations > 0) {
      return GenerationController.find.dailyGenerationCount <
          SettingsController.find.settingModel.freeGenerations;
    } else {
      return true;
    }
  }
}

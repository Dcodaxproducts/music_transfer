import 'package:intl/intl.dart';
import 'package:matrix_ai/features/home/data/repository/generation_repo_interface.dart';
import 'package:matrix_ai/features/home/domain/service/generation_service.dart';

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
  Future<void> resetDailyGenerationCount() async {
    final key = _generateKey();
    await generationRepoInterface.setDailyGenerationCount(key, 0);
  }
}

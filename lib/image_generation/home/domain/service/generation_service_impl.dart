import 'package:intl/intl.dart';
import 'package:pixart_app/image_generation/home/data/repository/generation_repo.dart';
import 'package:pixart_app/image_generation/home/domain/service/generation_service.dart';

class GenerationServiceImpl implements GenerationService {
  final GenerationRepo generationRepoInterface;
  GenerationServiceImpl({required this.generationRepoInterface});
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
    final currentCount = await generationRepoInterface.getDailyGenerationCount(key);
    await generationRepoInterface.setDailyGenerationCount(key, currentCount + 1);
  }

  @override
  Future<void> resetDailyGenerationCount() async {
    final key = _generateKey();
    await generationRepoInterface.setDailyGenerationCount(key, 0);
  }
}

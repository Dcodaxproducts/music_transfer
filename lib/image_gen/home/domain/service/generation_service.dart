abstract class GenerationService {
  Future<int> loadDailyGenerationCount();
  Future<void> incrementDailyGenerationCount();
  Future<void> resetDailyGenerationCount();
}

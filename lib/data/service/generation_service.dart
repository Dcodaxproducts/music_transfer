abstract class GenerationServiceInterface {
  Future<int> loadDailyGenerationCount();
  Future<void> incrementDailyGenerationCount();
  Future<void> resetDailyGenerationCount();
}

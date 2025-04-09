abstract class GenerationRepoInterface {
  Future<int> getDailyGenerationCount(String key);
  Future<void> setDailyGenerationCount(String key, int count);
}

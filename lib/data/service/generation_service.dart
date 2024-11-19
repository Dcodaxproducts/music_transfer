abstract class GenerationServiceInterface {
  Future<int> loadDailyGenerationCount();
  Future<void> incrementDailyGenerationCount();
  bool canGenerateImage();
}

import 'dart:math' as math;
import '../../../../features/ads/presentation/controller/ads_controller.dart';
import '../../aspect_ratio/data/model/aspect_ratio.dart';
import '../../models/data/model/model.dart';
import '../../prompt_setting/presentation/controller/settings_controller.dart';

class ImageGenerationUtils {
  static Future<void> showAdAccordingToGeneration(
    int freeGenerations,
    int dailyGenerationCount,
  ) async {
    // if first generation is free
    if (dailyGenerationCount == 0) {
      return;
    }

    if (dailyGenerationCount % 3 == 0) {
      await AdsController.find.showOnGenerateInterstitial();
    }
    return;
  }

  static AspectRatioModel getAspectRatio() {
    return aspectRatios.firstWhere(
      (e) => e.id == SettingsController.find.configModel.aspectRatio,
    );
  }

  static Model getModel(Model? model) {
    // if model is not null check if it is available in the models list and get it from the list
    if (model != null) {
      return model;
    }
    return model ?? SettingsController.find.configModel.selectedModel!;
  }

  static int generateSeed() {
    return math.Random().nextInt(10000);
  }

  static bool isSuccessResponse(Map<String, dynamic> data) {
    return data.containsKey("status") && data["status"] == "succeeded";
  }
}

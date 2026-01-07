import 'dart:math' as math;
import 'package:pixart_app/image_generation/home/presentation/controller/models_controller.dart';
import '../../../features/ads/presentation/controller/ads_controller.dart';
import '../data/model/aspect_ratio.dart';
import '../data/model/model.dart';

class ImageGenerationUtils {
  static Future<void> showAdAccordingToGeneration(int freeGenerations, int dailyGenerationCount) async {
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
    return aspectRatios.firstWhere((e) => e.id == ModelsController.find.selectedAspectRatio.id);
  }

  static Model getModel(Model? model) {
    // if model is not null check if it is available in the models list and get it from the list
    if (model != null) {
      return model;
    }
    return model ?? ModelsController.find.selectedModel!;
  }

  static int generateSeed() {
    return math.Random().nextInt(10000);
  }

  static bool isSuccessResponse(Map<String, dynamic> data) {
    return data.containsKey("status") && data["status"] == "succeeded";
  }
}

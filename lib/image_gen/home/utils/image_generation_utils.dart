import 'dart:math' as math;
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import '../data/model/aspect_ratio.dart';

class ImageGenerationUtils {
  static AspectRatioModel getAspectRatio() {
    return aspectRatios.firstWhere((e) => e.id == ModelsController.find.selectedAspectRatio.id);
  }

  static int generateSeed() {
    return math.Random().nextInt(10000);
  }

  static bool isSuccessResponse(Map<String, dynamic> data) {
    return data.containsKey("status") && data["status"] == "succeeded";
  }
}

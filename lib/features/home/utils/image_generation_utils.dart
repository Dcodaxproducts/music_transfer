import 'dart:math' as math;

class ImageGenerationUtils {
  static int generateSeed() {
    return math.Random().nextInt(10000);
  }

  static bool isSuccessResponse(Map<String, dynamic> data) {
    return data.containsKey("status") && data["status"] == "succeeded";
  }
}

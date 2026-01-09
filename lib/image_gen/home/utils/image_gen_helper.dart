import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import '../../../features/paywall/presentation/controller/subscription_controller.dart';
import '../../../imports.dart';
import '../data/model/image_generation.dart';

class ImageGenerationHelper {
  // Handles the tap action for generating an image
  static void handleTap() {
    final String text = ImageGenController.find.promptController.text;

    // Validate prompt
    if (text.isEmpty) {
      showToast('please_enter_prompt'.tr);
      return;
    } else if (ImageGenController.find.hasOffensiveWords) {
      showToast('please_remove_offensive_words'.tr);
      return;
    } else {
      return handleImageGeneration(text);
    }
  }

  static void handleImageGeneration(String text) {
    // Check subscription status and model type
    if (SubscriptionController.find.isPro) {
      return _handleProUser(text);
    } else {
      return _handleFreeUser(text);
    }
  }

  static void _handleProUser(String text) {
    generateImage(text);
  }

  static void _handleFreeUser(String text) {
    if (_isProModel()) {
      SubscriptionController.find.showPaywallIfNeeded();
    } else {
      generateImage(text);
    }
  }

  static bool _isProModel() => ModelsController.find.selectedModel?.isPro ?? false;

  // Generates an image based on the provided text prompt
  static Future<ImageGenerationResult?> generateImage(String text) async {
    ImageGenerationResult? result = await ImageGenController.find.generateImages(text);
    ImageGenController.find.promptController.clear();
    ImageGenController.find.attachedImage = null;
    return result;
  }
}

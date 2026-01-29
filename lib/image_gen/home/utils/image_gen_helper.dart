import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import '../../../features/paywall/presentation/controller/subscription_controller.dart';
import '../../../imports.dart';
import '../data/model/image_generation.dart';
import '../data/model/model.dart';

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
      return _handleUser(text);
    }
  }

  static void _handleUser(String text) {
    // Check subscription status and model type
    if (SubscriptionController.find.isPro) {
      return _handleCredits(text);
    } else {
      return _handleFreeUser(text);
    }
  }

  static void _handleFreeUser(String text) {
    if (ModelsController.find.selectedModel?.isPro ?? false) {
      SubscriptionController.find.showPaywallIfNeeded();
      return;
    } else {
      _handleCredits(text);
    }
  }

  static void _handleCredits(String text) {
    Model? model = ModelsController.find.selectedModel;

    if (model == null) {
      showToast('No model available');
      return;
    }

    if (AuthController.find.credits < model.creditsPerImage) {
      showToast('Not enough credits available');
      return;
    }

    generateImage(text, model);
  }

  // Generates an image based on the provided text prompt
  static Future<ImageGenerationResult?> generateImage(String text, Model model) async {
    ImageGenerationResult? result = await ImageGenController.find.generateImages(text, model);

    if (result != null) {
      // Clear prompt and attached image after generation
      ImageGenController.find.promptController.clear();
      ImageGenController.find.attachedImage = null;
    }
    return result;
  }
}

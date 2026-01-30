import 'package:pixart_app/features/ads/presentation/controller/ads_controller.dart';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import '../../../features/paywall/presentation/controller/subscription_controller.dart';
import '../../../features/profile/presentation/controller/profile_controller.dart';
import '../../../imports.dart';
import '../data/model/image_generation.dart';
import '../data/model/model.dart';
import '../presentation/widgets/watch_ads_dialog.dart';

class ImageGenerationHelper {
  // Handles the tap action for generating an image
  static void handleTap() async {
    final String text = ImageGenController.find.promptController.text;

    Model? model = ModelsController.find.selectedModel;

    // Validate prompt
    if (text.isEmpty) {
      showToast('please_enter_prompt'.tr);
      return;
    }

    // Validate model requirements
    if (ModelsController.find.selectedModel == null) {
      showToast('please_select_a_model'.tr);
      return;
    }

    // Validate offensive words
    if (ImageGenController.find.hasOffensiveWords) {
      showToast('please_remove_offensive_words'.tr);
      return;
    }

    //  Validate attached images if required
    if (ModelsController.find.selectedModel!.requiresImage &&
        ImageGenController.find.attachedImages.isEmpty) {
      showToast('this_model_requires_an_input_for_editing'.tr);
      return;
    }

    // Check user credits
    if (AuthController.find.credits < model!.creditsPerImage) {
      SubscriptionController.find.showPaywallIfNeeded();
      return;
    }

    // Check subscription status and model type
    if (SubscriptionController.find.isPro) {
      await generateImage(text, model);
      return;
    } else {
      return _handleFreeUser(text, model);
    }
  }

  static void _handleFreeUser(String text, Model model) async {
    if (ModelsController.find.selectedModel?.isPro ?? false) {
      SubscriptionController.find.showPaywallIfNeeded();
      return;
    } else {
      await WatchAdsDialog.show(
        Get.context!,
        onWatchAd: () async {
          await AdsController.find.showOnGenerateVideo();
          await generateImage(text, model);
        },
        onUpgrade: SubscriptionController.find.showPaywallIfNeeded,
      );
      return;
    }
  }

  // Generates an image based on the provided text prompt
  static Future<ImageGenerationResult?> generateImage(String text, Model model) async {
    ImageGenerationResult? result = await ImageGenController.find.generateImages(text, model);

    if (result != null) {
      // Clear prompt and attached image after generation
      ImageGenController.find.promptController.clear();
      ImageGenController.find.clearImages();

      ProfileController.find.updateProfile(); // update profile to refresh credits
    }
    return result;
  }
}

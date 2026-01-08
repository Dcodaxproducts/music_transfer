import 'package:pixart_app/image_gen/home/presentation/controller/generation_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import 'package:pixart_app/image_gen/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/features/ads/presentation/view/ads_dialog.dart';
import '../../../features/paywall/presentation/controller/subscription_controller.dart';
import '../../../imports.dart';
import '../data/model/image_generation.dart';
import '../presentation/widgets/free_generations.dart';

class ImageGenerationHelper {
  static Future<void> handleTap(Function(String) handleImageGeneration) async {
    final settings = SettingsController.find;
    final text = settings.promptController.text;

    if (_isPromptEmpty(text)) {
      showToast('please_enter_prompt'.tr);
    } else if (_hasOffensiveWords()) {
      showToast('please_remove_offensive_words'.tr);
    } else {
      handleImageGeneration(text);
    }
  }

  static bool _isPromptEmpty(String text) => text.isEmpty;

  static bool _hasOffensiveWords() => SettingsController.find.hasOffensiveWords;

  static Future<void> handleImageGeneration(
    String text, {
    required Function(String, {bool showAds}) generateImage,
  }) async {
    if (SubscriptionController.find.isPro) {
      await _handleProUser(text, generateImage: generateImage);
    } else {
      _handleFreeUser(text, generateImage: generateImage);
    }
  }

  static Future<void> _handleProUser(
    String text, {
    required Function(String, {bool showAds}) generateImage,
  }) async {
    if (GenerationController.find.proUserLimitExceeded) {
      bool hasShowedFreeLimitDialog = await ImageGenController.find.hasShowedFreeLimitDialog();
      if (hasShowedFreeLimitDialog) {
        await showFreeLimitDialog();
        return;
      }
    } else {
      generateImage(text);
    }
  }

  static void _handleFreeUser(String text, {required Function(String, {bool showAds}) generateImage}) {
    if (_isProModel()) {
      SubscriptionController.find.showPaywallIfNeeded();
    } else {
      _handleFreeUserGeneration(text, generateImage: generateImage);
    }
  }

  static Future<void> _handleFreeUserGeneration(
    String text, {
    required Function(String, {bool showAds}) generateImage,
  }) async {
    bool hasShowedFreeLimitDialog = await ImageGenController.find.hasShowedFreeLimitDialog();
    if (hasShowedFreeLimitDialog) {
      await showFreeLimitDialog();
      return;
    } else {
      if (GenerationController.find.dailyGenerationCount == 0) {
        generateImage(text, showAds: false);
      } else {
        // for now we are showing ads only on iOS devices
        // if (Platform.isAndroid) {
        //   generateImage(text);
        // } else {
        showAdsDialog(
          onWatchAdPressed: () {
            pop();
            generateImage(text);
          },
        );
        // }
      }
    }
  }

  static bool _isProModel() => ModelsController.find.selectedModel?.isPro ?? false;

  static Future<ImageGenerationResult?> generateImage(String text, {bool showAds = true}) async {
    return await ImageGenController.find.generateImages(text, showAds: showAds);
  }
}

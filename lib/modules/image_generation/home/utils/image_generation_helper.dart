import 'package:get/get.dart';
import 'package:pixart_app/modules/image_generation/home/presentation/controller/generation_controller.dart';
import 'package:pixart_app/modules/image_generation/home/presentation/controller/image_generation_controller.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/features/subscription/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/features/ads/presentation/view/ads_dialog.dart';
import 'package:pixart_app/features/loading_screen/src/loading_manager.dart';
import 'package:pixart_app/core/helper/navigation.dart';
import 'package:pixart_app/core/widgets/snackbar.dart';
import 'package:pixart_app/features/review/presentation/view/rate_us_sheet.dart';
import 'package:pixart_app/features/subscription/presentation/view/subscription.dart';
import '../../preview/presentation/view/image_gen_result.dart';
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
      bool hasShowedFreeLimitDialog = await ImageGenerationController.find.hasShowedFreeLimitDialog();
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
      showPremiumSheet();
    } else {
      _handleFreeUserGeneration(text, generateImage: generateImage);
    }
  }

  static Future<void> _handleFreeUserGeneration(
    String text, {
    required Function(String, {bool showAds}) generateImage,
  }) async {
    bool hasShowedFreeLimitDialog = await ImageGenerationController.find.hasShowedFreeLimitDialog();
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

  static bool _isProModel() => SettingsController.find.configModel.selectedModel?.premium ?? false;

  static void generateImage(String text, {bool showAds = true, int? seed}) {
    ImageGenerationController.find.generateImages(text, seed: seed, showAds: showAds).then((response) async {
      if (response != null) {
        bool fromRegenerate = seed != null;
        if (fromRegenerate) {
          pop();
        }
        LoadingManager.complete();
        launchScreen(PreviewScreen(result: response), replace: fromRegenerate);
        Future.delayed(const Duration(seconds: 2), () {
          showConditionalRateUsDialog();
        });
      }
    });
  }
}

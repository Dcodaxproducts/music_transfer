import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/image_generation/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/modules/image_generation/home/presentation/controller/generation_controller.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/repository/image_gen_repo.dart';
import 'package:pixart_app/features/ads/data/utils/firebase_events.dart';
import 'package:pixart_app/features/loading_screen/src/loading_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../../core/widgets/confirmation_dialog.dart';
import '../../../../../features/subscription/presentation/controller/subscription_controller.dart';
import '../../../aspect_ratio/data/model/aspect_ratio.dart';
import '../../data/model/image_generation.dart';
import '../../../models/data/model/model.dart';
import '../../utils/image_generation_utils.dart';
import 'image_generation_service_interface.dart';

class ImageGenerationServiceImpl implements ImageGenerationService {
  final ImageGenRepo repo;
  ImageGenerationServiceImpl({required this.repo});

  Future<void> _showAds() async {
    if (isPro) return Future.value();
    return ImageGenerationUtils.showAdAccordingToGeneration(
      SettingsController.find.settingModel.freeGenerations,
      GenerationController.find.dailyGenerationCount,
    );
  }

  @override
  Future<bool> willShowFreeLimitDialog(int freeGenerations, int dailyGenerationCount) async {
    // if generation feature is disabled
    if (SettingsController.find.settingModel.freeGenerations == 0) {
      return Future.value(false);
    }
    // daily generation limit exceeded
    bool proUserCondition = dailyGenerationCount >= AppConstants.proUserDailyLimit;

    // free generation limit exceeded
    int count = freeGenerations - dailyGenerationCount;
    bool freeUserCondition = count <= 0 || count.isNegative;

    bool condition = isPro ? proUserCondition : freeUserCondition;
    return Future.value(condition);
  }

  @override
  Future<http.Response?> generateImages(
    String prompt, {
    Model? modelValue,
    bool showAds = true,
    int? seed,
  }) async {
    // show ads
    if (showAds) {
      await _showAds();
    }

    LoadingManager.show(upscale: true);
    LoadingManager.updateProgress(1);

    // get model (selected or from models list)
    Model model = ImageGenerationUtils.getModel(modelValue);

    // get aspect ratio
    AspectRatioModel size = ImageGenerationUtils.getAspectRatio();

    // generate seed
    int seedValue = seed ?? ImageGenerationUtils.generateSeed();

    // negative prompt
    String negativePrompt = SettingsController.find.configModel.negativePrompt;

    // guidance scale
    double guidanceScale = SettingsController.find.configModel.guidanceScale;

    Map<String, dynamic> body = {
      "token": Endpoints.token,
      "prompt": prompt,
      "model_id": model.id,
      "width": size.width,
      "height": size.height,
      "seed": seedValue,
      "negative_prompt": negativePrompt,
      "guidance_scale": guidanceScale,
    };

    // send request to api
    return await repo.generateImages(body);
  }

  // process generation response
  @override
  ImageGenerationResult? processGenerationResponse(http.Response? response) {
    if (response == null) return null;

    Map<String, dynamic> data = jsonDecode(response.body);

    // Check if the response is successful
    if (!ImageGenerationUtils.isSuccessResponse(data)) {
      showErrorDialog();
      return null;
    }

    GenerationController.find.incrementGenerationCount();

    LoadingManager.updateProgress(2);

    ImageGenerationResult value = ImageGenerationResult.fromJson(data);

    //  log impression for model to track usage to firebase
    PackageInfo? packageInfo = SettingsController.find.packageInfo;
    EventsHelper.logEvent('model_impression', {
      'model': value.meta.model.name,
      'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
    });

    HistoryController.find.addPrompt(value);

    return value;
  }

  @override
  Future<void> cancelRequest() async {
    await repo.cancelRequest();
  }
}

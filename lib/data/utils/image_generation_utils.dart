import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:matrix_ai/controller/models_controller.dart';
import '../../controller/aws_controller.dart';
import '../../view/base/common/snackbar.dart';
import '../../controller/ads_controller.dart';
import '../model/body/aspect_ratio.dart';
import '../model/body/config_model.dart';
import '../model/response/models_lab_response.dart';
import '../model/response/model.dart';
import '../../controller/settings_controller.dart';
import '../model/response/together_ai_response.dart';

class ImageGenerationUtils {
  static Future<bool> showAdAccordingToGeneration(int freeGenerations, int dailyGenerationCount) async {
    // if generation feature is disabled or first generation is free
    if (SettingsController.find.settingModel.freeGenerations == 0 || dailyGenerationCount == 0) {
      return Future.value(true);
    }

    //  show video or interstitial ad based on even or odd
    if (dailyGenerationCount.isOdd) {
      await AdsController.find.showOnGenerateVideo();
    } else {
      await AdsController.find.showOnGenerateInterstitial();
    }
    return Future.value(true);
  }

  static AspectRatioModel getAspectRatio() {
    return aspectRatios.firstWhere(
      (e) => e.id == SettingsController.find.configModel.aspectRatio,
    );
  }

  static Model getModel(Model? model) {
    // if model is not null check if it is available in the models list and get it from the list
    if (model != null) {
      final models = ModelsController.find.models;
      if (models.any((e) => e.id == model.id)) {
        return models.firstWhere((e) => e.modelId == model.modelId);
      }
    }
    return model ?? SettingsController.find.configModel.selectedModel!;
  }

  static Map<String, dynamic> createRequestBody(
    String prompt,
    AspectRatioModel size,
    Model model,
    int? seed,
    bool upscale,
    bool faceFix,
  ) {
    // get the model api parameters
    final body = {...model.apiParameters};

    // get the model parameters mapping
    ParameterMapping params = model.parametersMapping;

    // get the config model
    ConfigModel config = SettingsController.find.configModel;

    // add the prompt to the body
    body[params.prompt] = prompt;

    // (if prompt engineering is enabled, add the prompt engineering to the prompt)
    if (model.promptEngeenring != null) {
      body[params.prompt] = '$prompt(${model.promptEngeenring!})';
    }

    // add the model id to the body
    body[params.modelId] = model.modelId;

    // add the negative prompt to the body
    body[params.negativePrompt] = config.negativePrompt;

    // add the guidance scale to the body
    body[params.cfgScale] = config.guidanceScale.toString();

    // if upscale is enabled and the model supports upscaling, add upscale to the body
    if (upscale && body.containsKey('upscale')) {
      body['upscale'] = 2;
    }

    // if face fix is enabled and the model supports face fix, add face fix to the body
    if (faceFix && body.containsKey('highres_fix')) body['highres_fix'] = 'yes';

    // if seed is not null, add seed to the body
    if (seed != null) body['seed'] = ImageGenerationUtils.isTogetherAi(model) ? seed : seed.toString();

    // if the model supports aspect ratio, add aspect ratio to the body
    if (params.aspectRatio != null) {
      body[params.aspectRatio!] = size.aspectRatio;
    }

    // if the model supports width and height, add width and height to the body
    if (params.width != null && params.height != null) {
      body[params.width!] = size.width;
      body[params.height!] = size.height;
    }

    // if the model supports the api key in the body, add the api key to the body
    if (model.apiKeyLoation == 'body') {
      body['key'] = model.apiKey;
    }

    return body;
  }

  static bool isSuccessResponse(Map<String, dynamic> data) {
    if (data['status'] == 'error') {
      String message = '';
      final res = data['message'] ?? data['messege'];
      if (res is String) {
        message = res;
      } else {
        Map<String, dynamic> messageMap = res;
        message = messageMap.entries.first.value[0];
      }
      if (kDebugMode) {
        showToast(message);
      } else {
        showToast('too_many_requests');
      }
      dismiss();
      return false;
    }
    return true;
  }

  static Future<PromptResponse> getPromptResponse(Map<String, dynamic> data, [String? prompt]) async {
    if (data['status'] != null) {
      return PromptResponse.fromJson(data);
    } else {
      TogetherAiRespsonse response = TogetherAiRespsonse.fromJson(data);
      final List<String> urls = response.data.map((e) => e.url).toList();
      String? imageUrl = await AwsController.find.downloadImageAndUploadToAWS(urls.first, prompt);
      int randomSeed = Random(30).nextInt(10000);
      final promptResponse = PromptResponse(
        status: 'success',
        id: DateTime.now().millisecondsSinceEpoch,
        meta: Meta(h: 1, w: 1, prompt: '', seed: randomSeed),
        eta: null,
        output: imageUrl != null ? [imageUrl] : urls,
        futureLinks: [],
      );
      // if success and fast ai model then add delay of 4 seconds
      return await Future.delayed(const Duration(seconds: 6), () => promptResponse);
    }
  }

  static Map<String, dynamic> getHeaders(Model model) {
    return model.apiKeyLoation == 'header' ? {'Authorization': 'Bearer ${model.apiKey}'} : {};
  }

  static bool isTogetherAi(Model model) {
    return model.apiUrl.contains('together');
  }

  static int generateSeed() {
    return Random().nextInt(10000);
  }
}

import 'dart:convert';
import 'package:matrix_ai/controller/generation_controller.dart';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:http/http.dart' as http;
import 'package:matrix_ai/data/repository/image_generation_repo_interface.dart';
import '../../common/snackbar.dart';
import '../../controller/ads_controller.dart';
import '../../controller/models_controller.dart';
import '../../controller/settings_controller.dart';
import '../../controller/subscription_controller.dart';
import '../model/body/aspect_ratio.dart';
import '../model/response/api_response.dart';
import '../model/response/model.dart';
import 'image_generation_service_interface.dart';

class ImageGenerationService implements ImageGenerationServiceInterface {
  final ImageGenerationRepoInterface imageGenerationRepo;
  ImageGenerationService({required this.imageGenerationRepo});

  @override
  Future<http.Response?> generateImages(
    String prompt,
    String negativePrompt,
    double cfgScale, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    String? modelId,
  }) async {
    if (!_canGenerateImage()) return null;

    MyModel model = _getModel(modelId);

    _showAds(model);

    AspectRatioModel size = _getAspectRatio();

    String apiUrl = model.apiUrl;

    Map<String, dynamic> headers = _getHeaders(model);

    Map<String, dynamic> body =
        _createRequestBody(prompt, '', 9, size, model, seed, upscale, faceFix);

    return await imageGenerationRepo.generateImages(
        url: apiUrl, body: body, headers: headers);
  }

  bool _canGenerateImage() {
    if (!GenerationController.find.canGenerateImage && !isPro) {
      showToast('You have reached the daily generation limit');
      // showPremiumSheet();
      return false;
    }
    return true;
  }

  Future<void> _showAds(MyModel model) async {
    if (!isPro) {
      if (model.adType == AdType.rewardVideo &&
          ModelsController.find.canShowVideoAd()) {
        await AdsController.find.showOnGenerateRewardVideo();
      } else if (model.adType == AdType.rewardInterstitial &&
          ModelsController.find.canShowInterstitialAd()) {
        await AdsController.find.showOnGenerateInterstitial();
      }
    }
  }

  AspectRatioModel _getAspectRatio() {
    return aspectRatios.firstWhere(
        (e) => e.id == SetttingsController.find.configModel.aspectRatio);
  }

  MyModel _getModel(String? modelId) {
    final controller = ModelsController.find;
    return modelId != null
        ? controller.models.firstWhere((e) => e.modelId == modelId)
        : controller.selectedModel;
  }

  Map<String, dynamic> _getHeaders(MyModel model) {
    return model.apiKeyLoation == 'header'
        ? {'Authorization': 'Bearer ${model.apiKey}'}
        : {};
  }

  Map<String, dynamic> _createRequestBody(
    String prompt,
    String userNegativePrompt,
    int cfgScale,
    AspectRatioModel size,
    MyModel model,
    int? seed,
    bool upscale,
    bool faceFix,
  ) {
    //
    final body = {...model.apiParameters};

    // Add user inputs with mapped parameter names
    body[model.parametersMapping.prompt] = prompt;
    body[model.parametersMapping.negativePrompt] = userNegativePrompt;
    body[model.parametersMapping.cfgScale] = cfgScale.toString();
    if (model.parametersMapping.aspectRatio != null) {
      body[model.parametersMapping.aspectRatio!] = size.aspectRatio;
    }
    if (model.parametersMapping.width != null &&
        model.parametersMapping.height != null) {
      body[model.parametersMapping.width!] = size.width.toString();
      body[model.parametersMapping.height!] = size.height.toString();
    }

    if (model.apiKeyLoation == 'body') {
      body['apiKey'] = model.apiKey;
    }

    return body;
  }

  // process generation response
  @override
  PromptResponse? processGenerationResponse(
      http.Response? response, String prompt, String? modelId, bool upscale) {
    if (response == null) return null;
    Map<String, dynamic> data = jsonDecode(response.body);

    if (!_handleErrorResponse(data)) return null;

    GenerationController.find.incrementGenerationCount();

    PromptResponse value = PromptResponse.fromJson(data);

    MyModel model = _getModel(modelId);

    AspectRatioModel size = _getAspectRatio();

    // replace prompt with original prompt
    value = value.copyWith(
      meta: value.meta.copyWith(
        prompt: prompt,
        model: model.modelId.startsWith('https') ? model.modelId : null,
        h: (size.height.toInt()) * (upscale ? 2 : 1),
        w: (size.width.toInt()) * (upscale ? 2 : 1),
      ),
      createdAt: DateTime.now(),
    );

    // add prompt history
    HistoryController.find.addPrompt(value);

    if (value.status == "success") {
      return value;
    } else if (value.status == "processing") {
      showToast('Your prompt is processing in the queue', success: true);
    } else {
      showToast(data["message"]);
    }
    dismiss();
    return null;
  }

  bool _handleErrorResponse(Map<String, dynamic> data) {
    if (data['status'] == 'error') {
      showToast(data['message']);
      dismiss();
      return false;
    }
    return true;
  }
}

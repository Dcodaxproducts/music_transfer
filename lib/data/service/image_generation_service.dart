import 'dart:convert';
import 'package:matrix_ai/controller/generation_controller.dart';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:http/http.dart' as http;
import 'package:matrix_ai/data/repository/image_generation_repo_interface.dart';
import '../../common/snackbar.dart';
import '../../controller/ads_controller.dart';
import '../../controller/models_controller.dart';
import '../../controller/subscription_controller.dart';
import '../../view/base/loading/prompt_loading.dart';
import '../model/body/aspect_ratio.dart';
import '../model/response/api_response.dart';
import '../model/response/model.dart';
import '../utils/image_generation_utils.dart';
import 'image_generation_service_interface.dart';

class ImageGenerationService implements ImageGenerationServiceInterface {
  final ImageGenerationRepoInterface imageGenerationRepo;
  ImageGenerationService({required this.imageGenerationRepo});

  bool _canGenerateImage() {
    if (!GenerationController.find.canGenerateImage && !isPro) {
      showToast('You have reached the daily generation limit');
      // showPremiumSheet();
      return false;
    }
    return true;
  }

  Future<void> _showAds(Model model) async {
    if (!isPro) {
      if (model.adType == AdType.rewardVideo &&
          ModelsController.find.canShowVideoAd()) {
        await AdsController.find.showRewardVideoAd();
      } else if (model.adType == AdType.rewardInterstitial &&
          ModelsController.find.canShowInterstitialAd()) {
        await AdsController.find.showInterstitialAd();
      }
    }
  }

  @override
  Future<http.Response?> generateImages(
    String prompt, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    Model? modelValue,
  }) async {
    // check if user can generate image (daily limit)
    if (!_canGenerateImage()) return null;

    // get model (selected or from models list)
    Model model = ImageGenerationUtils.getModel(modelValue);

    // show ads (if not pro user and model has ads)
    await _showAds(model);

    showPromptLoading(facefix: faceFix, upscale: upscale);

    // get aspect ratio
    AspectRatioModel size = ImageGenerationUtils.getAspectRatio();

    // get api url (the url to send the request to from the model)
    String apiUrl = model.apiUrl;

    // get headers (if api key is in header)
    Map<String, dynamic> headers = ImageGenerationUtils.getHeaders(model);

    // create request body (parameters to send to the api)
    Map<String, dynamic> body = ImageGenerationUtils.createRequestBody(
        prompt, size, model, seed, upscale, faceFix);

    // send request to api
    return await imageGenerationRepo.generateImages(
      url: apiUrl,
      body: body,
      headers: headers,
    );
  }

  bool _handleErrorResponse(Map<String, dynamic> data) {
    if (data['status'] == 'error') {
      String message = '';
      final res = data['message'] ?? data['messege'];
      if (res is String) {
        message = res;
      } else {
        Map<String, dynamic> messageMap = res;
        message = messageMap.entries.first.value[0];
      }
      showToast(message);
      dismiss();
      return false;
    }
    return true;
  }

  // process generation response
  @override
  PromptResponse? processGenerationResponse(
    http.Response? response,
    String prompt,
    Model? modelValue,
    bool upscale,
    int? seed,
  ) {
    if (response == null) return null;
    Map<String, dynamic> data = jsonDecode(response.body);

    if (!_handleErrorResponse(data)) return null;

    GenerationController.find.incrementGenerationCount();

    PromptResponse value = PromptResponse.fromJson(data);

    Model model = ImageGenerationUtils.getModel(modelValue);

    AspectRatioModel size = ImageGenerationUtils.getAspectRatio();

    // replace prompt with original prompt
    value = value.copyWith(
      meta: value.meta.copyWith(
        prompt: prompt,
        h: (size.height.toInt()) * (upscale ? 2 : 1),
        w: (size.width.toInt()) * (upscale ? 2 : 1),
      ),
      createdAt: DateTime.now(),
      model: model,
    );

    // add prompt history
    HistoryController.find.addPrompt(value, seed: seed);

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

  @override
  Future<bool> getQueuedImages(PromptResponse value) async {
    // Save the original value in case of rollback
    PromptResponse oldResponse = value;
    http.Response? response =
        await imageGenerationRepo.getQueueImage(requestId: value.id);

    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == "success") {
        final List<String> output = List<String>.from(data['output']);

        // Update response with new data
        value = value.copyWith(status: 'success', output: output);

        // Update the history
        HistoryController.find.removePrompt(oldResponse);
        HistoryController.find.addPrompt(value);

        return true;
      }
    }
    return false;
  }

  @override
  void toggleFavorite(PromptResponse promptResponse) {
    // Toggle the bookmarked status
    PromptResponse updatedResponse = promptResponse.copyWith(
      bookmarked: !promptResponse.bookmarked,
    );
    // Update history and UI
    HistoryController.find.toggleFavourite(updatedResponse);
  }
}

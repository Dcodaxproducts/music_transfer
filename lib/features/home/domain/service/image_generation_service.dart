import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:matrix_ai/features/aws/presentation/controller/aws_controller.dart';
import 'package:matrix_ai/features/home/presentation/controller/generation_controller.dart';
import 'package:matrix_ai/features/history/presentation/controller/history_controller.dart';
import 'package:http/http.dart' as http;
import 'package:matrix_ai/features/settings/presentation/controller/settings_controller.dart';
import 'package:matrix_ai/features/home/data/model/api_model.dart';
import 'package:matrix_ai/features/home/data/repository/image_generation_repo_interface.dart';
import 'package:matrix_ai/features/ads/data/utils/firebase_events.dart';
import 'package:matrix_ai/core/utils/images.dart';
import 'package:matrix_ai/features/loading_screen/presentation/view/src/loading_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/widgets/snackbar.dart';
import '../../../subscription/presentation/controller/subscription_controller.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../aspect_ratio/data/model/aspect_ratio.dart';
import '../../data/model/models_lab_response.dart';
import '../../../models/data/model/model.dart';
import '../../data/utils/image_generation_utils.dart';
import 'image_generation_service_interface.dart';

class ImageGenerationService implements ImageGenerationServiceInterface {
  final ImageGenerationRepoInterface imageGenerationRepo;
  ImageGenerationService({required this.imageGenerationRepo});

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
    bool proUserCondition = dailyGenerationCount >= AppConstants.PRO_USER_DAILY_LIMIT;

    // free generation limit exceeded
    int count = freeGenerations - dailyGenerationCount;
    bool freeUserCondition = count <= 0 || count.isNegative;

    bool condition = isPro ? proUserCondition : freeUserCondition;
    return Future.value(condition);
  }

  @override
  Future<ApiKeyModel?> getTogetherApiKey(Model? modelValue) async {
    LoadingManager.show();
    Model model = ImageGenerationUtils.getModel(modelValue);
    bool isTogetherAi = ImageGenerationUtils.isTogetherAi(model);
    await Future.delayed(Duration(seconds: model.delay));
    if (isTogetherAi) {
      http.Response? response = await imageGenerationRepo.getTogetherApiKey();
      if (response != null) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return ApiKeyModel.fromJson(data);
      }
    }
    return null;
  }

  @override
  Future<http.Response?> generateImages(
    String prompt, {
    int? seed,
    Model? modelValue,
    bool showAds = true,
    String? apiKey,
  }) async {
    // show ads
    if (showAds) {
      await _showAds();
    }

    // update progress
    LoadingManager.updateProgress(1);

    // get model (selected or from models list)
    Model model = ImageGenerationUtils.getModel(modelValue);

    // get aspect ratio
    AspectRatioModel size = ImageGenerationUtils.getAspectRatio();

    // get api url (the url to send the request to from the model)
    String apiUrl = model.apiUrl;

    // get headers (if api key is in header)
    Map<String, dynamic> headers = ImageGenerationUtils.getHeaders(model, apiKey);

    // create request body (parameters to send to the api)
    Map<String, dynamic> body = ImageGenerationUtils.createRequestBody(prompt, size, model, seed, apiKey);

    // send request to api
    return await imageGenerationRepo.generateImages(url: apiUrl, body: body, headers: headers);
  }

  // process generation response
  @override
  Future<PromptResponse?> processGenerationResponse(
    http.Response? response,
    String prompt,
    Model? modelValue,
    int? seed,
  ) async {
    if (response == null) return null;
    Map<String, dynamic> data = jsonDecode(response.body);

    if (!ImageGenerationUtils.isSuccessResponse(data)) return null;

    GenerationController.find.incrementGenerationCount();

    Model model = ImageGenerationUtils.getModel(modelValue);

    LoadingManager.updateProgress(2);

    PromptResponse value = await ImageGenerationUtils.getPromptResponse(data, prompt);

    LoadingManager.updateProgress(3);

    // replace prompt with original prompt
    value = value.copyWith(
      meta: value.meta.copyWith(prompt: prompt, seed: ImageGenerationUtils.isTogetherAi(model) ? seed : null),
      createdAt: DateTime.now(),
      model: model,
    );

    // add prompt history
    value = HistoryController.find.addPrompt(value, seed: seed);

    //  log impression for model to track usage to firebase
    PackageInfo? packageInfo = SettingsController.find.packageInfo;
    EventsHelper.logEvent(
      'model_impression',
      {
        'model': model.name,
        'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
        'platform': Platform.isAndroid ? 'Android' : 'iOS',
      },
    );

    if (value.status == "success") {
      return value;
    } else if (value.status == "processing") {
      await LoadingManager.queue();
      showToast('your_prompt_is_processing_in_the_queue', success: true);
    } else if (value.status == "queued") {
      await LoadingManager.error();
      // if genration failed then add link to output
      value = value.copyWith(
        output: [...value.output, Images.generationFailed],
        futureLinks: [value.futureLinks.first],
      );
    } else {
      await LoadingManager.error();
      showToast(data["message"]);
    }
    return null;
  }

  @override
  Future<bool> getQueuedImages(PromptResponse value) async {
    // Save the original value in case of rollback
    PromptResponse oldResponse = value;

    // prepare body
    Map<String, dynamic> body = {"key": value.model!.apiKey, "request_id": value.id};

    // get queue url
    String url = value.model!.queueUrl;

    http.Response? response = await imageGenerationRepo.getQueueImage(url: url, body: body);

    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == "success") {
        final List<String> output = List<String>.from(data['output']);

        // Update response with new data
        value = value.copyWith(status: 'success', output: output);

        // Update the history
        HistoryController.find.removePrompt(oldResponse);
        HistoryController.find.addPrompt(value);
        AwsController.find.downloadImageAndUploadToAWS(value.output.first);
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> cancelRequest() async {
    await imageGenerationRepo.cancelRequest();
  }

  @override
  int? getSeed(int? seed, Model? model) {
    Model modelValue = ImageGenerationUtils.getModel(model);
    if (seed == null && ImageGenerationUtils.isTogetherAi(modelValue)) {
      return ImageGenerationUtils.generateSeed();
    }
    return seed;
  }
}

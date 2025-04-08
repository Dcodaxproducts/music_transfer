import 'package:matrix_ai/features/history/presentation/controller/history_controller.dart';
import 'package:matrix_ai/features/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:matrix_ai/features/home/data/model/api_model.dart';
import 'package:matrix_ai/features/home/data/model/models_lab_response.dart';
import 'package:matrix_ai/features/models/data/model/model.dart';
import 'package:matrix_ai/features/home/domain/service/image_generation_service_interface.dart';
import 'package:http/http.dart' as http;
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/features/loading_screen/presentation/view/src/loading_manager.dart';
import 'generation_controller.dart';

class ImageGenerationController extends GetxController implements GetxService {
  final ImageGenerationServiceInterface imageGenerationServiceInterface;
  ImageGenerationController({required this.imageGenerationServiceInterface});

  static ImageGenerationController get find => Get.find<ImageGenerationController>();

  ImageGenerationResult? _imageGenerationResult;
  String? _imageUrl;

  ImageGenerationResult? get imageGenerationResult => _imageGenerationResult;
  String? get imageUrl => _imageUrl;

  set imageGenerationResult(ImageGenerationResult? value) {
    _imageGenerationResult = value;
    Future.delayed(const Duration(milliseconds: 10), () => update());
  }

  set imageUrl(String? value) {
    _imageUrl = value;
    Future.delayed(const Duration(milliseconds: 10), () => update());
  }

  Future<ImageGenerationResult?> generateImages(
    String prompt, {
    int? seed,
    bool upscale = false,
    bool faceFix = false,
    Model? model,
    bool showAds = true,
  }) async {
    seed = imageGenerationServiceInterface.getSeed(seed, model);

    ApiKeyModel? apiKeyModel = await imageGenerationServiceInterface.getTogetherApiKey(model);
    if (apiKeyModel == null) {
      LoadingManager.error();
      return null;
    }

    //
    http.Response? response = await imageGenerationServiceInterface.generateImages(
      prompt,
      seed: seed,
      modelValue: model,
      showAds: showAds,
      apiKey: apiKeyModel.apiKey,
    );

    //
    ImageGenerationResult? value = await imageGenerationServiceInterface.processGenerationResponse(
      response,
      prompt,
      model,
      seed,
    );

    return value;
  }

  // get queque images
  Future<bool> getQueuedImages(ImageGenerationResult response) async {
    return await imageGenerationServiceInterface.getQueuedImages(response);
  }

  Future<void> cancelRequest() async {
    await imageGenerationServiceInterface.cancelRequest();
  }

  Future<bool> hasShowedFreeLimitDialog() async {
    return imageGenerationServiceInterface.willShowFreeLimitDialog(
      SettingsController.find.settingModel.freeGenerations,
      GenerationController.find.dailyGenerationCount,
    );
  }

  ImageGenerationResult? getResponseById(int id) {
    return HistoryController.find.getResponseById(id);
  }

  ImageGenerationResult? getResponseByImageUrl(String imageUrl) {
    return HistoryController.find.getResponseByImageUrl(imageUrl);
  }
}

import 'package:pixart_app/modules/image_generation/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/api_model.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:pixart_app/modules/image_generation/models/data/model/model.dart';
import 'package:pixart_app/modules/image_generation/home/domain/service/image_generation_service_interface.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/loading_screen/presentation/view/src/loading_manager.dart';
import 'generation_controller.dart';

class ImageGenerationController extends GetxController implements GetxService {
  final ImageGenerationServiceInterface imageGenerationServiceInterface;
  ImageGenerationController({required this.imageGenerationServiceInterface});

  static ImageGenerationController get find => Get.find<ImageGenerationController>();

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

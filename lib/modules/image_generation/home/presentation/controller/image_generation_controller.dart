import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import 'package:pixart_app/modules/image_generation/models/data/model/model.dart';
import 'package:pixart_app/modules/image_generation/home/domain/service/image_generation_service_interface.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/imports.dart';
import 'generation_controller.dart';

class ImageGenerationController extends GetxController implements GetxService {
  final ImageGenerationService service;
  ImageGenerationController({required this.service});

  static ImageGenerationController get find =>
      Get.find<ImageGenerationController>();

  ImageGenerationResult? _result;
  ImageGenerationResult? get result => _result;
  set result(ImageGenerationResult? value) {
    _result = value;
    update();
  }

  Future<ImageGenerationResult?> generateImages(
    String prompt, {
    Model? model,
    int? seed,
    bool showAds = true,
  }) async {
    http.Response? response = await service.generateImages(
      prompt,
      modelValue: model,
      showAds: showAds,
      seed: seed,
    );

    ImageGenerationResult? value = service.processGenerationResponse(response);

    return value;
  }

  Future<void> cancelRequest() async {
    await service.cancelRequest();
  }

  Future<bool> hasShowedFreeLimitDialog() async {
    return service.willShowFreeLimitDialog(
      SettingsController.find.settingModel.freeGenerations,
      GenerationController.find.dailyGenerationCount,
    );
  }
}

import 'package:pixart_app/image_gen/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';
import 'package:pixart_app/image_gen/home/data/model/model.dart';
import 'package:pixart_app/image_gen/home/domain/service/image_generation_service_impl.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/imports.dart';
import 'generation_controller.dart';

class ImageGenController extends GetxController implements GetxService {
  final ImageGenService service;
  ImageGenController({required this.service});

  static ImageGenController get find => Get.find<ImageGenController>();

  ImageGenerationResult? _result;
  ImageGenerationResult? get result => _result;
  set result(ImageGenerationResult? value) {
    _result = value;
    update();
  }

  final List<bool> _loading = [];
  List<bool> get loading => _loading;

  Future<ImageGenerationResult?> generateImages(
    String prompt, {
    Model? model,
    bool showAds = true,
    XFile? attachedImage,
  }) async {
    // Start loading
    _loading.add(true);
    update();

    // Make request
    http.Response? response = await service.generateImages(
      prompt,
      modelValue: model,
      showAds: showAds,
      attachedImage: attachedImage,
    );

    // Process response
    ImageGenerationResult? value = service.processGenerationResponse(response);

    // End loading
    _loading.removeLast();
    update();
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

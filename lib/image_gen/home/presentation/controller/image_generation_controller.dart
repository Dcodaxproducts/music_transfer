import 'package:pixart_app/image_gen/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';
import 'package:pixart_app/image_gen/home/data/model/model.dart';
import 'package:pixart_app/image_gen/home/domain/service/image_gen_service.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/imports.dart';
import 'generation_controller.dart';

class ImageGenController extends GetxController implements GetxService {
  final ImageGenService service;
  ImageGenController({required this.service});

  static ImageGenController get find => Get.find<ImageGenController>();

  XFile? _attachedImage;
  XFile? get attachedImage => _attachedImage;
  set attachedImage(XFile? value) {
    _attachedImage = value;
    update();
  }

  ImageGenerationResult? _result;
  ImageGenerationResult? get result => _result;
  set result(ImageGenerationResult? value) {
    _result = value;
    update();
  }

  final List<bool> _loading = [];
  List<bool> get loading => _loading;

  Future<ImageGenerationResult?> generateImages(String prompt, {Model? model, bool showAds = true}) async {
    try {
      // Start loading
      _loading.add(true);
      update();

      // Prepare attached image
      List<XFile>? images;
      if (_attachedImage != null) {
        images = [_attachedImage!];
      }

      // Make request
      http.Response? response = await service.generateImages(
        prompt,
        modelValue: model,
        showAds: showAds,
        images: images,
      );

      // Process response
      ImageGenerationResult? value = service.processGenerationResponse(response);

      return value;
    } catch (e) {
      return null;
    } finally {
      // End loading
      _loading.removeLast();
      update();
    }
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

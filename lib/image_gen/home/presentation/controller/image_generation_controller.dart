import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';
import 'package:pixart_app/image_gen/home/data/model/model.dart';
import 'package:pixart_app/image_gen/home/domain/service/image_gen_service.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/imports.dart';
import 'text_editing_controller.dart';

class ImageGenController extends GetxController implements GetxService {
  final ImageGenService service;
  ImageGenController({required this.service});

  static ImageGenController get find => Get.find<ImageGenController>();

  // Text controllers for user input
  final promptController = StyleableTextFieldController(
    styles: TextPartStyleDefinitions(definitionList: [], adultWords: AppConstants.adultWords),
  );

  bool get hasOffensiveWords {
    bool isOffensive = false;
    final textParts = promptController.text.split(' ');
    for (final textPart in textParts) {
      if (AppConstants.adultWords.contains(removePunctuation(textPart.toLowerCase()))) {
        isOffensive = true;
        break;
      }
    }
    return isOffensive;
  }

  List<XFile> _attachedImages = [];
  List<XFile> get attachedImages => _attachedImages;
  set attachedImages(List<XFile> value) {
    _attachedImages = value;
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

  Future<ImageGenerationResult?> generateImages(String prompt, Model model) async {
    try {
      // Start loading
      _loading.add(true);
      update();

      // Prepare attached image
      List<XFile>? images;
      if (_attachedImages.isNotEmpty) {
        images = _attachedImages;
      }

      // Make request
      http.Response? response = await service.generateImages(prompt, model, images: images);

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

  void clearImages() {
    _attachedImages.clear();
    update();
  }

  void addImages(List<XFile> images) {
    _attachedImages.addAll(images);
    update();
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < _attachedImages.length) {
      _attachedImages.removeAt(index);
      update();
    }
  }
}

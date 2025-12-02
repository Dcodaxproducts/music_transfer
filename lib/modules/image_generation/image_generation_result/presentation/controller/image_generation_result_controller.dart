import 'package:pixart_app/modules/image_generation/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:pixart_app/imports.dart';

class ImageGenerationResultController extends GetxController implements GetxService {
  static ImageGenerationResultController get find => Get.find<ImageGenerationResultController>();

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

  ImageGenerationResult? getResponseById(int id) {
    return HistoryController.find.getResponseById(id);
  }

  ImageGenerationResult? getResponseByImageUrl(String imageUrl) {
    return HistoryController.find.getResponseByImageUrl(imageUrl);
  }
}

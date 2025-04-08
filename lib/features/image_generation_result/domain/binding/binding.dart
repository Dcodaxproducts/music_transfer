import '../../../../imports.dart';
import '../../presentation/controller/image_generation_result_controller.dart';

class ImageGenerationResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImageGenerationResultController(), fenix: true);
  }
}

import 'package:get/get.dart';
import 'package:pixart_app/features/tools/presentation/controller/tools_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/models_controller.dart';
import 'package:pixart_app/image_gen/inspirations/presentation/controller/inspiration_controller.dart';

class DashboardController extends GetxController implements GetxService {
  static DashboardController get find => Get.find<DashboardController>();

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    update();
    getData();
  }

  void toHome() {
    selectedIndex = 0;
    update();
  }

  void getData() {
    switch (selectedIndex) {
      case 0:
        ModelsController.find.getModels();
        break;
      case 1:
        ToolsController.find.getTools();
        break;
      case 2:
        InspirationController.find.getInspirations();
        break;
      default:
        break;
    }
  }
}

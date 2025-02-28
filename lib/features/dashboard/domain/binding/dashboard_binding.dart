import 'package:get/get.dart';
import '../../presentation/controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // controller
    Get.lazyPut(() => DashboardController());
  }
}

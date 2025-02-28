import 'package:get/get.dart';
import 'package:matrix_ai/features/subscription/domain/service/subscription_service_interface.dart';
import '../../presentation/controller/subscription_controller.dart';
import '../service/subscription_service.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    // service
    SubscriptionServiceInterface subscriptionServiceInterface = SubscriptionService();
    Get.lazyPut(() => subscriptionServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => SubscriptionController(subscriptionService: Get.find()));
  }
}

import 'package:get/get.dart';
import '../../data/repository/subscription_repo.dart';
import '../../data/repository/subscription_repo_impl.dart';
import '../../presentation/controller/subscription_controller.dart';
import '../srevice/subscription_service.dart';
import '../srevice/subscription_service_impl.dart';

/// Dependency injection binding for RevenueCat feature
class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<SubscriptionRepo>(() => SubscriptionRepoImpl(storage: Get.find()));

    // Service
    Get.lazyPut<SubscriptionService>(() => SubscriptionServiceImpl(revenueCatRepo: Get.find()));

    // Controller
    Get.lazyPut(() => SubscriptionController(revenueCatService: Get.find()));

    // initialize
    Get.find<SubscriptionController>().initialize();
  }
}

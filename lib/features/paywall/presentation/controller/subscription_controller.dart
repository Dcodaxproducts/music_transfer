import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/paywall/data/model/revenuecat_config.dart';
import 'package:pixart_app/features/profile/presentation/controller/profile_controller.dart';
import '../../../../imports.dart';
import '../../../auth/data/model/user_model.dart';
import '../../domain/srevice/subscription_service.dart';
import '../view/pro_success_screen.dart';

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionService revenueCatService;
  SubscriptionController({required this.revenueCatService});

  static SubscriptionController get find => Get.find<SubscriptionController>();

  bool get isPro => AuthController.find.user?.isPro ?? false;

  CustomerInfo? _customerInfo;
  CustomerInfo? get customerInfo => _customerInfo;
  set customerInfo(CustomerInfo? value) {
    _customerInfo = value;
    update();
  }

  /// Initialize RevenueCat with configuration
  Future<void> initialize() async {
    await revenueCatService.initialize(RevenueCatConfig.defaultConfig);
    await refreshCustomerInfo();
    ProfileController.find.updateProfile();
  }

  /// Refresh customer info and premium status
  Future<void> refreshCustomerInfo({CustomerInfo? info}) async {
    customerInfo = info ?? await revenueCatService.getCustomerInfo();
    log(customerInfo?.toJson().toString() ?? 'No customer info available');
  }

  Future<void> showPaywallIfNeeded({Function()? onSuccess}) async {
    if (isPro) return; // Already premium, no need to show paywall

    final bool result = await revenueCatService.showPaywall();
    // Refresh data after potential purchase
    if (result) {
      await refreshCustomerInfo();
      if (isPro) {
        await showPurchaseSuccess(() => onSuccess?.call());
      }
    }
  }

  Future<void> login(UserModel user) async {
    try {
      await revenueCatService.login(user);
      await refreshCustomerInfo();
    } catch (e) {
      debugPrint('Error during RevenueCat login: $e');
    }
  }
}

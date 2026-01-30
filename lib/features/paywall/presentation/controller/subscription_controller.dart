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

  /// Initialize RevenueCat with configuration
  Future<void> initialize() async {
    await revenueCatService.initialize(RevenueCatConfig.defaultConfig);
  }

  Future<void> showPaywallIfNeeded({Function()? onSuccess}) async {
    if (isPro) return; // Already premium, no need to show paywall

    final bool result = await revenueCatService.showPaywall();
    await ProfileController.find.updateProfile();

    // Refresh data after potential purchase
    if (result && isPro) {
      await showPurchaseSuccess(() => onSuccess?.call());
    }
  }

  Future<void> login(UserModel user) async {
    try {
      await revenueCatService.login(user);
    } catch (e) {
      debugPrint('Error during RevenueCat login: $e');
    }
  }
}

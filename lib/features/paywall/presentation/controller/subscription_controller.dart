import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/profile/presentation/controller/profile_controller.dart';
import '../../../../imports.dart';
import '../../../auth/data/model/user_model.dart';
import '../../domain/srevice/subscription_service.dart';
import '../view/pro_success_screen.dart';

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionService service;
  SubscriptionController({required this.service});

  static SubscriptionController get find => Get.find<SubscriptionController>();

  Offerings? _offerings;
  Offerings? get offerings => _offerings;

  CustomerInfo? _customerInfo;
  CustomerInfo? get customerInfo => _customerInfo;

  bool get isPro {
    EntitlementInfos? entitlements = _customerInfo?.entitlements;
    if (entitlements == null || entitlements.active.isNotEmpty == false) {
      return false;
    }
    final DateTime now = DateTime.now().toLocal();
    final DateTime expiration = DateTime.parse(
      entitlements.active.values.first.expirationDate ?? '',
    ).toLocal();
    return AuthController.find.user?.isPro ?? now.isBefore(expiration);
  }

  // Initialize RevenueCat and fetch offerings
  Future<void> initialize() async {
    try {
      await service.initialize(); // Initialize RevenueCat SDK

      // Fetch offerings and customer info in parallel
      final List<dynamic> result = await Future.wait([Purchases.getOfferings(), fetchCustomerInfo()]);

      // Set offerings
      _offerings = result[0] as Offerings?;

      update();
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  Future<void> fetchCustomerInfo() async {
    try {
      _customerInfo = await service.getCustomerInfo();
      update();
    } catch (e) {
      debugPrint('Error fetching customer info: $e');
    }
  }

  Future<void> showPaywall({Offering? offering, Function()? onSuccess}) async {
    final bool result = await service.showPaywall();

    if (result) {
      // Update customer info and profile after purchase
      await Future.wait([fetchCustomerInfo(), ProfileController.find.updateProfile()]);

      // Show success screen if user is now Pro
      if (isPro) {
        await showPurchaseSuccess(() => onSuccess?.call());
      }
    }
  }

  Future<void> showPurchaseCreditsPaywall({Function()? onSuccess}) async {
    final String creditsOffering = 'credits';
    Offering? offering = _offerings?.getOffering(creditsOffering);

    return await showPaywall(offering: offering, onSuccess: onSuccess);
  }

  Future<void> login(UserModel user) async {
    try {
      await service.login(user);
    } catch (e) {
      debugPrint('Error during RevenueCat login: $e');
    }
  }
}

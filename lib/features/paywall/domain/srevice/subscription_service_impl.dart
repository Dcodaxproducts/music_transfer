import 'package:pixart_app/features/auth/data/model/user_model.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../../../../imports.dart';
import '../../data/model/revenuecat_config.dart';
import '../../data/repository/subscription_repo.dart';
import 'subscription_service.dart';

/// Service implementation for RevenueCat business logic
class SubscriptionServiceImpl implements SubscriptionService {
  final SubscriptionRepo revenueCatRepo;
  SubscriptionServiceImpl({required this.revenueCatRepo});

  @override
  Future<void> initialize(RevenueCatConfig config) async {
    try {
      // Configure RevenueCat with platform-specific API key
      final apiKey = Platform.isIOS ? config.iosApiKey : config.androidApiKey;

      final PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);

      // Initialize Purchases SDK
      await Purchases.configure(configuration);
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  @override
  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> showPaywall() async {
    try {
      PaywallResult result = await RevenueCatUI.presentPaywall();
      List<PaywallResult> potentialResults = [PaywallResult.purchased, PaywallResult.restored];
      return potentialResults.contains(result);
    } catch (e) {
      showToast('Error showing paywall: $e');
      return false;
    }
  }

  @override
  Future<void> login(UserModel user) async {
    try {
      // log in with new appUserId
      await Purchases.logIn(user.uid);

      // set attributes if provided
      if (user.email != null || user.name != null) {
        final Map<String, String> attributes = {};
        if (user.email != null) attributes['email'] = user.email ?? 'N/A';
        if (user.name != null) attributes['name'] = user.name ?? 'N/A';

        await Future.wait([
          Purchases.setAttributes(attributes),
          Purchases.setEmail(user.email ?? 'N/A'),
          Purchases.setDisplayName(user.name ?? 'N/A'),
        ]);

        showToast("User Logged in to RevenueCat as ${user.email}, ${user.name}, ${user.uid}");
      }
    } catch (e) {
      rethrow;
    }
  }
}

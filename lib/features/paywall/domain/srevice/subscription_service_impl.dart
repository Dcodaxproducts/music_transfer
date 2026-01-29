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
  Future<void> login(String appUserId) async {
    try {
      await Purchases.logOut();
      await Purchases.logIn(appUserId);
    } catch (e) {
      rethrow;
    }
  }
}

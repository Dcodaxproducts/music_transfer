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
  Future<void> initialize() async {
    try {
      await revenueCatRepo.initialize(RevenueCatConfig.defaultConfig);
    } catch (e) {
      showToast('Error initializing RevenueCat service: $e');
      rethrow;
    }
  }

  @override
  Future<CustomerInfo> getCustomerInfo() async {
    return await revenueCatRepo.getCustomerInfo();
  }

  @override
  Future<bool> showPaywall({Offering? offering}) async {
    try {
      PaywallResult result = await RevenueCatUI.presentPaywall(offering: offering);
      List<PaywallResult> potentialResults = [PaywallResult.purchased, PaywallResult.restored];
      // Analytics.paywallResult(result, offering?.identifier ?? 'main');
      return potentialResults.contains(result);
    } catch (e) {
      showToast('Error showing paywall: $e');
      return false;
    }
  }

  @override
  Future<CustomerInfo> restorePurchases() async {
    return await revenueCatRepo.restorePurchases();
  }

  @override
  Future<CustomerInfo> purchasePackage(Package package, {String? oldProductIdentifier}) async {
    if (oldProductIdentifier == null) {
      return await Purchases.purchasePackage(package);
    }
    GoogleProductChangeInfo info = GoogleProductChangeInfo(oldProductIdentifier);
    return await Purchases.purchasePackage(package, googleProductChangeInfo: info);
  }
}

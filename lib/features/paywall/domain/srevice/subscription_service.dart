import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionService {
  /// Initialize RevenueCat with configuration
  Future<void> initialize();

  /// Get current customer information
  Future<CustomerInfo> getCustomerInfo();

  /// Present paywall only if user doesn't have premium access
  Future<bool> showPaywall({Offering? offering});

  /// Restore user's purchases
  Future<CustomerInfo> restorePurchases();

  Future<CustomerInfo> purchasePackage(Package package, {String? oldProductIdentifier});
}

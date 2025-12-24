import 'package:purchases_flutter/purchases_flutter.dart';
import '../model/revenuecat_config.dart';

abstract class SubscriptionRepo {
  Future<void> initialize(RevenueCatConfig config);

  Future<CustomerInfo> getCustomerInfo();

  Future<CustomerInfo> restorePurchases();
}

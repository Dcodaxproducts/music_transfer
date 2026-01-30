import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../auth/data/model/user_model.dart';
import '../../data/model/revenuecat_config.dart';

abstract class SubscriptionService {
  // Initialize RevenueCat with configuration
  Future<void> initialize(RevenueCatConfig config);

  // Get current customer information
  Future<CustomerInfo> getCustomerInfo();

  // Present paywall only if user doesn't have premium access
  Future<bool> showPaywall();

  // Login
  Future<void> login(UserModel user);
}

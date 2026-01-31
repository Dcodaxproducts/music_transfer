import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../auth/data/model/user_model.dart';

abstract class SubscriptionService {
  Future<void> initialize();
  Future<CustomerInfo> getCustomerInfo();
  Future<bool> showPaywall();
  Future<void> login(UserModel user);
}

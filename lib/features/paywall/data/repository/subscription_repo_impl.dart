import 'package:pixart_app/imports.dart';
import 'subscription_repo.dart';

/// Repository implementation for RevenueCat operations
class SubscriptionRepoImpl implements SubscriptionRepo {
  final SharedPreferences storage;
  SubscriptionRepoImpl({required this.storage});
}

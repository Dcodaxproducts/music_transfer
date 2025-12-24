import 'package:pixart_app/imports.dart';
import '../model/revenuecat_config.dart';
import 'subscription_repo.dart';

/// Repository implementation for RevenueCat operations
class SubscriptionRepoImpl implements SubscriptionRepo {
  final SharedPreferences storage;
  SubscriptionRepoImpl({required this.storage});

  @override
  Future<void> initialize(RevenueCatConfig config) async {
    try {
      // Configure RevenueCat with platform-specific API key
      final apiKey = Platform.isIOS ? config.iosApiKey : config.androidApiKey;

      final configuration = PurchasesConfiguration(apiKey);

      // Set app user ID if provided
      if (config.appUserId != null) {
        configuration.appUserID = config.appUserId;
      }

      await Purchases.configure(configuration);
    } catch (e) {
      showToast('Error initializing RevenueCat: $e');
    }
  }

  @override
  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      showToast('Error fetching customer info: $e');
      rethrow;
    }
  }

  @override
  Future<CustomerInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      rethrow;
    }
  }
}

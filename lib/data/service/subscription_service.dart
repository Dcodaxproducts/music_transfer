import 'dart:async';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'subscription_service_interface.dart';

class SubscriptionService implements SubscriptionServiceInterface {
  final FlutterInappPurchase _iap = FlutterInappPurchase.instance;

  @override
  Future<void> initialize() async {
    await _iap.initialize();
  }

  @override
  Future<List<IAPItem>> getSubscriptions(List<String> subscriptionIds) async {
    return await _iap.getSubscriptions(subscriptionIds);
  }

  @override
  Future<void> requestSubscription(String productId) async {
    await _iap.requestSubscription(productId);
  }

  @override
  Future<List<PurchasedItem>?> getAvailablePurchases() async {
    return await _iap.getAvailablePurchases();
  }

  @override
  Future<void> finishTransaction(PurchasedItem result) async {
    await _iap.finishTransaction(result);
  }
}

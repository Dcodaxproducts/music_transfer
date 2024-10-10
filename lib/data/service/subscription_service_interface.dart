import 'dart:async';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

abstract class SubscriptionServiceInterface {
  Future<void> initialize();
  Future<List<IAPItem>> getSubscriptions(List<String> subscriptionIds);
  Future<void> requestSubscription(String productId);
  Future<List<PurchasedItem>?> getAvailablePurchases();
  Future<void> finishTransaction(PurchasedItem result);
}

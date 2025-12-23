// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:pixart_app/core/widgets/snackbar.dart';
import 'package:pixart_app/core/helper/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import '../../domain/service/subscription_service_interface.dart';

bool get isPro => SubscriptionController.find.isPro;

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionServiceInterface subscriptionService;
  SubscriptionController({required this.subscriptionService});

  static SubscriptionController get find => Get.find<SubscriptionController>();

  final List<String> _subscriptionIds = const <String>[
    'yearly_plan',
    'monthly_plan',
    'weekly_plan',
  ];
  List<IAPItem> _products = [];
  late StreamSubscription _purchaseUpdatedSubscription;
  DateTime? _proLimitDate;

  List<IAPItem> get products => _products;
  DateTime? get proLimitDate => _proLimitDate;

  set products(List<IAPItem> value) {
    _products = value;
    update();
  }

  set proLimitDate(DateTime? value) {
    _proLimitDate = value;
    update();
  }

  Future<void> initialize() async {
    await subscriptionService.initialize();
    await _getSubscriptions();
    await refreshProStatus();
    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((
      result,
    ) {
      _verifyPurchase(
        result,
        callback: () {
          pop();
          showToast('purchase_success'.tr);
        },
      );
    });
  }

  Future<void> _getSubscriptions() async {
    var data = await subscriptionService.getSubscriptions(_subscriptionIds);
    log('Subscriptions: $data');
    if (data.isNotEmpty) {
      products = data;
    }
  }

  Future<void> buyProduct(
    IAPItem productDetails, {
    Function()? callback,
  }) async {
    showLoading();
    Future.delayed(const Duration(seconds: 3), () {
      dismiss();
    });
    try {
      await subscriptionService.requestSubscription(productDetails.productId!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _verifyPurchase(
    PurchasedItem? result, {
    Function()? callback,
  }) async {
    if (result == null) {
      return; // Handle the case where the purchase is null
    }

    // Check if the purchase is successful
    if (Platform.isAndroid) {
      if (result.purchaseStateAndroid == PurchaseState.purchased) {
        await _finishTransaction(result, callback: callback);
      }
    } else {
      if (result.transactionStateIOS == TransactionState.purchased ||
          result.transactionStateIOS == TransactionState.restored) {
        await _finishTransaction(result, callback: callback);
      }
    }
  }

  Future<void> _finishTransaction(
    PurchasedItem result, {
    Function()? callback,
  }) async {
    DateTime? purchaseTime = result.transactionDate;

    switch (result.productId!.toLowerCase()) {
      case "yearly_plan":
        purchaseTime = purchaseTime?.add(const Duration(days: 365));
        break;
      case "monthly_plan":
        purchaseTime = purchaseTime?.add(const Duration(days: 30));
        break;
      case "weekly_plan":
        purchaseTime = purchaseTime?.add(const Duration(days: 7));
        break;

      default:
        return;
    }

    if (DateTime.now().isBefore(purchaseTime!)) {
      proLimitDate = purchaseTime;
    }
    try {
      await subscriptionService.finishTransaction(result);
      if (callback != null) callback.call();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> refreshProStatus() async {
    // Get past purchases
    var result = await subscriptionService.getAvailablePurchases();
    if (result != null && result.isNotEmpty) {
      for (var item in result) {
        _verifyPurchase(item);
      }
    }
  }

  // restore purchase
  Future<void> restorePurchase() async {
    var result = await subscriptionService.getPurchaseHistory();
    if (result != null && result.isNotEmpty) {
      for (var item in result) {
        _verifyPurchase(item);
      }
    }
  }

  bool get isPro {
    if (proLimitDate == null) {
      return false;
    } else {
      return DateTime.now().isBefore(proLimitDate!);
    }
  }

  @override
  void onClose() {
    _purchaseUpdatedSubscription.cancel();
    super.onClose();
  }
}

import 'dart:developer';

import 'package:flutter/services.dart';
import '../../../../imports.dart';
import '../../domain/srevice/subscription_service.dart';
import '../view/pro_success_screen.dart';

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionService revenueCatService;
  SubscriptionController({required this.revenueCatService});

  static SubscriptionController get find => Get.find<SubscriptionController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool get isPro {
    EntitlementInfos? entitlements = _customerInfo?.entitlements;
    if (entitlements == null || entitlements.active.isNotEmpty == false) {
      return false;
    }
    final DateTime now = DateTime.now().toLocal();
    final DateTime expiration = DateTime.parse(
      entitlements.active.values.first.expirationDate ?? '',
    ).toLocal();
    return now.isBefore(expiration);
  }

  CustomerInfo? _customerInfo;
  CustomerInfo? get customerInfo => _customerInfo;
  set customerInfo(CustomerInfo? value) {
    _customerInfo = value;
    update();
  }

  Offerings? _offerings;
  Offerings? get offerings => _offerings;
  set offerings(Offerings? value) {
    _offerings = value;
    update();
  }

  /// Initialize RevenueCat with configuration
  Future<void> initialize() async {
    await revenueCatService.initialize();
    _fetchOffering();
    await refreshCustomerInfo();
  }

  /// Refresh customer info and premium status
  Future<void> refreshCustomerInfo({CustomerInfo? info}) async {
    customerInfo = info ?? await revenueCatService.getCustomerInfo();
  }

  Future<void> showPaywallIfNeeded({Offering? offering, Function()? onSuccess}) async {
    if (isPro) return; // Already premium, no need to show paywall
    if (offering == null) {
      // Analytics.paywallViewed('main');
    }
    final bool result = await revenueCatService.showPaywall(offering: offering);
    // Refresh data after potential purchase
    if (result) {
      await refreshCustomerInfo();
      await showPurchaseSuccess(() {
        onSuccess?.call();
      });
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    final CustomerInfo info = await revenueCatService.restorePurchases();
    _customerInfo = info;

    await refreshCustomerInfo();

    if (isPro) {
      showToast('purchases_restored');
    } else {
      showToast('no_active_purchases');
    }
  }

  Future<void> _fetchOffering() async {
    try {
      offerings = await Purchases.getOfferings();
      log('Offerings fetched: ${offerings?.all.keys.toList()}');
    } catch (e) {
      showToast('Error fetching offerings: $e');
    }
  }

  Package? getPackageByProductId(String productId) {
    try {
      return offerings?.all.values
          .map((offering) => offering.availablePackages)
          .expand((packages) => packages)
          .firstWhere((package) => package.storeProduct.defaultOption?.productId == productId);
    } catch (e) {
      return null;
    }
  }

  Future<void> purchasePackage(Package package, {Function()? onSuccess}) async {
    try {
      isLoading = true;
      CustomerInfo info = await revenueCatService.purchasePackage(
        package,
        oldProductIdentifier: existingSubscriptionProductId(),
      );
      await refreshCustomerInfo(info: info);
      isLoading = false;
      // Analytics.purchaseSuccess(package);
      await showPurchaseSuccess(() {
        onSuccess?.call();
      });
    } catch (e) {
      isLoading = false;
      String message = 'Purchase failed. Please try again.';
      if (e is PlatformException) {
        message = e.message ?? message;
      }
      showToast(message);
    }
  }

  // get product id of exisiting subscription if any
  String? existingSubscriptionProductId() {
    EntitlementInfos? entitlements = _customerInfo?.entitlements;
    if (entitlements == null || entitlements.active.isNotEmpty == false) {
      return null;
    }
    return entitlements.active.values.first.productIdentifier;
  }

  bool isPackageAlreadyPurchased(Package package) {
    final existingProductId = existingSubscriptionProductId();
    if (existingProductId == null) return false;
    return existingProductId == package.storeProduct.defaultOption?.productId;
  }

  Future<void> showInAppPurchase({Function()? onSuccess}) async {
    Offering? offering = offerings?.current;
    if (offering == null || offering.availablePackages.isEmpty) {
      showToast('No available packages for purchase at the moment.');
      return;
    }
    Package package = offering.availablePackages.first;
    await purchasePackage(package, onSuccess: onSuccess);
  }
}

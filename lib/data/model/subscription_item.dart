import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';

class SubscriptionItem {
  final String title;
  final String subtitle;
  final String price;
  final String promotionText;
  final IAPItem? product;

  SubscriptionItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.promotionText,
    this.product,
  });

  // add method for default weekly subscription
  static SubscriptionItem weeklySubscription(List<IAPItem> products) {
    IAPItem? product = products.firstWhereOrNull((element) => element.productId == 'weekly_plan');
    String price = Platform.isIOS ? '\$6.99' : '\$4.99';
    return SubscriptionItem(
      title: 'weekly',
      subtitle: 'test_ad_free_for_a_week',
      price: product?.localizedPrice ?? price,
      promotionText: '',
      product: product,
    );
  }

  // add method for default monthly subscription
  static SubscriptionItem monthlySubscription(List<IAPItem> products) {
    IAPItem? product = products.firstWhereOrNull((element) => element.productId == 'monthly_plan');
    String price = Platform.isIOS ? '\$23.99' : '\$14.99';
    String subtitlePrice = Platform.isIOS ? '\$5.99' : '\$3.99';
    return SubscriptionItem(
      title: 'monthly',
      subtitle: '${'only'.tr} $subtitlePrice/ ${'week'.tr}, ${'enjoy_a_month_of_no_ads'.tr}!',
      price: product?.localizedPrice ?? price,
      promotionText: '14% ${'off'.tr}',
      product: product,
    );
  }

  // add method for default yearly subscription,
  static SubscriptionItem yearlySubscription(List<IAPItem> products) {
    IAPItem? product = products.firstWhereOrNull((element) => element.productId == 'yearly_plan');
    String price = Platform.isIOS ? '\$84.99' : '\$69.99';
    String subtitlePrice = Platform.isIOS ? '\$7.50' : '\$5.99';
    String promotionalText = Platform.isIOS ? '75% ${'off'.tr}' : '70% ${'off'.tr}';
    return SubscriptionItem(
      title: 'yearly',
      subtitle: '${'only'.tr} $subtitlePrice/ ${'month'.tr}, ${'enjoy_a_year_of_no_ads'.tr}!',
      price: product?.localizedPrice ?? price,
      promotionText: promotionalText,
      product: product,
    );
  }
}

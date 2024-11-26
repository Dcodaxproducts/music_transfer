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
    IAPItem? product = products
        .firstWhereOrNull((element) => element.productId == 'weekly_plan');
    return SubscriptionItem(
      title: 'weekly',
      subtitle: 'test_ad_free_for_a_week',
      price: product?.localizedPrice ?? "\$6.99",
      promotionText: '',
      product: product,
    );
  }

  // add method for default monthly subscription
  static SubscriptionItem monthlySubscription(List<IAPItem> products) {
    IAPItem? product = products
        .firstWhereOrNull((element) => element.productId == 'monthly_plan');
    return SubscriptionItem(
      title: 'monthly',
      subtitle:
          '${'only'.tr} \$5.99/ ${'week'.tr}, ${'enjoy_a_month_of_no_ads'.tr}!',
      price: product?.localizedPrice ?? '\$23.99',
      promotionText: '14% ${'off'.tr}',
      product: product,
    );
  }

  // add method for default yearly subscription,
  static SubscriptionItem yearlySubscription(List<IAPItem> products) {
    IAPItem? product = products
        .firstWhereOrNull((element) => element.productId == 'yearly_plan');
    return SubscriptionItem(
      title: 'yearly',
      subtitle:
          '${'only'.tr} \$7.50/ ${'month'.tr}, ${'enjoy_a_year_of_no_ads'.tr}!',
      price: product?.localizedPrice ?? '\$84.99',
      promotionText: '75% ${'off'.tr}',
      product: product,
    );
  }
}

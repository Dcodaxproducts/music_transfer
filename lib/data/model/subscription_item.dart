import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

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
}

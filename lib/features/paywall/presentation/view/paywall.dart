import 'package:pixart_app/features/paywall/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/imports.dart';
import 'package:purchases_ui_flutter/views/paywall_view.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Offering? offering = SubscriptionController.find.offerings?.current;
    return PaywallView(offering: offering, onDismiss: Get.back);
  }
}

import 'package:pixart_app/imports.dart';
import 'package:purchases_ui_flutter/views/paywall_view.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaywallView(onDismiss: Get.back);
  }
}

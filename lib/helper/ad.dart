// ignore_for_file: implementation_imports

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import '../controller/subscription_controller.dart';

extension CheckProForAd on AdWithoutView {
  Future<void> showIfNotPro() async {
    if (!SubscriptionController.find.isPro) {
      await instanceManager.showAdWithoutView(this);
    }
  }
}

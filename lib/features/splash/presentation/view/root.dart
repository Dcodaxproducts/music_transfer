import 'dart:async';
import 'package:pixart_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import 'package:pixart_app/features/welcome/presentation/view/welcome.dart';
import '../../../inspirations/presentation/controller/inspiration_controller.dart';
import '../../../ads/presentation/controller/ads_controller.dart';
import '../../../home/presentation/controller/models_controller.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../paywall/presentation/controller/subscription_controller.dart';
import 'splash.dart';

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  final ValueNotifier<bool> _ready = ValueNotifier(false);

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    _getDataFromApi();
    await AdsController.find.initialize();
    await _loadAppOpenAd();
  }

  Future<void> _getDataFromApi() async {
    await Future.wait([
      SplashController.find.initialize(),
      ModelsController.find.getModels(),
      InspirationController.find.getInspirations(),
      AuthController.find.initialize(),
    ]);
  }

  Future<void> _loadAppOpenAd() async {
    if (SplashController.find.isFirstTime) {
      _ready.value = true;
      return;
    }
    bool success = await AdsController.find.showAppOpenAd(onAdDismissed: _showPaywallIfNeeded);
    if (!success) {
      _showPaywallIfNeeded();
    }
  }

  void _showPaywallIfNeeded() {
    _ready.value = true;
    if (!SubscriptionController.find.isPro) {
      Future.delayed(const Duration(milliseconds: 250), SubscriptionController.find.showPaywall);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _ready,
      builder: (context, ready, child) {
        if (_ready.value) {
          return GetBuilder<SplashController>(
            builder: (setting) {
              return setting.isFirstTime ? const WelcomeScreen() : const DashboardScreen();
            },
          );
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}

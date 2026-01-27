import 'dart:async';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import 'package:pixart_app/features/welcome/presentation/view/welcome.dart';
import '../../../../image_gen/inspirations/presentation/controller/inspiration_controller.dart';
import '../../../ads/presentation/controller/ads_controller.dart';
import '../../../../image_gen/home/presentation/controller/models_controller.dart';
import 'splash.dart';

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  bool _ready = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    // get data from api
    await _getDataFromApi();

    // show add
    await _loadAppOpenAd();

    //
    _ready = true;
    if (mounted) setState(() {});
  }

  Future<void> _getDataFromApi() async {
    Future.wait([
      AdsController.find.initialize(),
      ModelsController.find.getModels(),
      AuthController.find.initialize(),
      InspirationController.find.getInspirations(),
    ]);
  }

  Future<bool> _loadAppOpenAd() async {
    return AdsController.find.showAppOpenAd();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return GetBuilder<SplashController>(
        builder: (setting) {
          return setting.isFirstTime ? const WelcomeScreen() : const DashboardScreen();
        },
      );
    } else {
      return const SplashScreen();
    }
  }
}

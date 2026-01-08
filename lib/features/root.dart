// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pixart_app/features/review/presentation/controller/review_controller.dart';
import 'package:pixart_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import 'package:pixart_app/features/welcome/presentation/view/welcome.dart';
import 'ads/presentation/controller/ads_controller.dart';
import '../image_gen/home/presentation/controller/generation_controller.dart';
import '../image_gen/history/presentation/controller/history_controller.dart';
import '../image_gen/inspirations/presentation/controller/inspiration_controller.dart';
import '../image_gen/home/presentation/controller/models_controller.dart';
import '../core/widgets/no_internet_dialog.dart';
import 'splash/presentation/view/splash.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  bool _ready = false;

  bool _disconnected = false;
  bool get disconnected => _disconnected;
  set disconnected(bool value) {
    _disconnected = value;
    if (mounted) setState(() {});
  }

  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    if (!(await isConnected())) {
      disconnected = true;
    }

    // check internet connection
    _checkInternetConnection();

    // add observer
    WidgetsBinding.instance.addObserver(this);

    //
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      // load ad network
      await _loadAdNetwork();

      // get history from shared preferences
      _getHistoryFromPrefs();

      //get data from api
      await _getDataFromApi();

      // show add
      await _loadAppOpenAd();

      //
      _ready = true;
      if (mounted) setState(() {});
    });
  }

  void _checkInternetConnection() {
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        disconnected = true;
      } else {
        disconnected = false;
      }
    });
  }

  Future<void> _loadAdNetwork() async {
    if (GetPlatform.isAndroid) {
      await EasyAudienceNetwork.init(testingId: '5cfcb5cc-93c0-4edf-9e36-a09fda9c6495');
    } else {
      await MobileAds.instance.initialize();
    }
  }

  void _getHistoryFromPrefs() {
    HistoryController.find.initPromptHistory();
    ReviewController.find.checkReviewed();
  }

  Future<void> _getDataFromApi() async {
    await Future.wait([
      GenerationController.find.initialize(),
      AdsController.find.initialize(),
      ModelsController.find.getModels(),
      InspirationController.find.getInspirations(),
    ]);
  }

  @override
  void dispose() {
    _onConnectivityChanged?.cancel();
    super.dispose();
  }

  Future<bool> _loadAppOpenAd() async {
    return AdsController.find.showAppOpenAd();
  }

  @override
  Widget build(BuildContext context) {
    if (disconnected) {
      return const NoInternetDialog();
    } else if (_ready) {
      return GetBuilder<SplashController>(
        builder: (settingController) {
          return settingController.isFirstTime ? const WelcomeScreen() : const DashboardScreen();
        },
      );
    } else {
      return const SplashScreen();
    }
  }
}

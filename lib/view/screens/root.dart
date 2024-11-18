// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/view/screens/dashboard/dashboard.dart';
import '../../controller/ads_controller.dart';
import '../../controller/history_controller.dart';
import '../../controller/inspiration_controller.dart';
import '../../controller/models_controller.dart';
import '../../controller/subscription_controller.dart';
import '../base/no_internet_dialog.dart';
import '../../helper/ad.dart';
import 'splash/splash.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  bool _ready = false;
  AppOpenAd? _appOpenAd;
  Timer? openAdTimeout;

  bool _disconnected = false;
  bool get disconnected => _disconnected;
  set disconnected(bool value) {
    _disconnected = value;
    if (mounted) setState(() {});
  }

  DateTime _lastShownTime = DateTime.now();
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

    _checkInternetConnection();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      // get history from shared preferences
      HistoryController.find.initPromptHistory();

      //get data from api
      await Future.wait([
        AdsController.find.initialize(),
        ModelsController.find.getModels(),
        InspirationController.find.getInspirations()
      ]);

      // show add
      await _loadAppOpenAd().then((value) async {
        await _appOpenAd?.showIfNotPro();
      }).catchError((e) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      });
      //
      Future.delayed(const Duration(seconds: 3)).then((value) {
        _ready = true;
        if (mounted) setState(() {});
      });
      await SubscriptionController.find.initialize().catchError((_) {});
    });
  }

  _checkInternetConnection() {
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        disconnected = true;
      } else {
        disconnected = false;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    openAdTimeout?.cancel();
    _onConnectivityChanged?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_lastShownTime.difference(DateTime.now()).inMinutes > 5) {
        _appOpenAd?.showIfNotPro().catchError((e) {});
        _lastShownTime = DateTime.now();
      }
    } else if (state == AppLifecycleState.paused) {
      _loadAppOpenAd();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<AppOpenAd?> _loadAppOpenAd() async {
    openAdTimeout?.cancel();

    return AdsController.find.showAppOpenAd().then((value) {
      if (value != null) {
        _appOpenAd = value;
        _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            _appOpenAd?.dispose();
            _appOpenAd = null;
            _loadAppOpenAd();
          },
        );
      } else {
        openAdTimeout = Timer(const Duration(minutes: 1), _loadAppOpenAd);
      }
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (disconnected) {
      return const NoInternetDialog();
    } else if (_ready) {
      return const DashboardScreen();
    } else {
      return const SplashScreen();
    }
  }
}

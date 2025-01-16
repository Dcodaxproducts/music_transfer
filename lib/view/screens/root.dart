// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:matrix_ai/controller/aws_controller.dart';
import 'package:matrix_ai/controller/review_controller.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/view/screens/dashboard/dashboard.dart';
import '../../controller/ads_controller.dart';
import '../../controller/generation_controller.dart';
import '../../controller/history_controller.dart';
import '../../controller/inspiration_controller.dart';
import '../../controller/models_controller.dart';
import '../../controller/subscription_controller.dart';
import '../base/no_internet_dialog.dart';
import '../../helper/ad.dart';
import 'splash/splash.dart';
import 'package:easy_audience_network/easy_audience_network.dart' as meta;

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  bool _ready = false;
  AppOpenAd? _appOpenAd;
  meta.InterstitialAd? _appOpenFacebook;
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
      ReviewController.find.checkReviewed();
      SettingsController.find.initSharedData();
      // init aws
      AwsController.find.initAWS();
      //get data from api
      await Future.wait([
        GenerationController.find.initialize(),
        AdsController.find.initialize(),
        ModelsController.find.getModels(),
        InspirationController.find.getInspirations(),
        SettingsController.find.getSettings(),
      ]);

      await SubscriptionController.find.initialize().catchError((_) {});

      // show add
      if (GetPlatform.isIOS) {
        await _loadAppOpenAd().then((value) async {
          await _appOpenAd?.showIfNotPro();
        }).catchError((e) {
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        });
      } else {
        await _loadAppOpenAdFacebook().then((value) async {
          await _appOpenFacebook?.show();
        }).catchError((e) {
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        });
      }
      //
      _ready = true;
      if (mounted) setState(() {});
    });
  }

  _checkInternetConnection() {
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
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
        if (GetPlatform.isIOS) {
          _appOpenAd?.showIfNotPro().catchError((e) {});
        } else {
          _appOpenFacebook?.show().catchError((e) {});
        }
        _lastShownTime = DateTime.now();
      }
    } else if (state == AppLifecycleState.paused) {
      if (GetPlatform.isIOS) {
        _loadAppOpenAd();
      } else {
        _loadAppOpenAdFacebook();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<AppOpenAd?> _loadAppOpenAd() async {
    if (!SettingsController.find.showAppOpen || SubscriptionController.find.isPro) return null;
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

  Future<meta.InterstitialAd?> _loadAppOpenAdFacebook() async {
    if (!SettingsController.find.showAppOpen || SubscriptionController.find.isPro) return null;
    openAdTimeout?.cancel();

    return AdsController.find.showAppOpenAdFacebook().then((value) {
      if (value != null) {
        _appOpenFacebook = value;
        _appOpenFacebook?.listener = meta.InterstitialAdListener(
          onDismissed: () {
            _appOpenFacebook?.destroy();
            _appOpenFacebook = null;
            _loadAppOpenAdFacebook();
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

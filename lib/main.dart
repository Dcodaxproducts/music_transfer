// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';
import 'utils/scroll_behavior.dart';
import 'view/base/common/loading.dart';
import 'controller/localization_controller.dart';
import 'controller/theme_controller.dart';
import 'firebase_options.dart';
import 'helper/notification_helper.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';
import 'utils/app_constants.dart';
import 'utils/messages.dart';
import 'helper/get_di.dart' as di;
import 'view/screens/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // disable landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // initialize localization
  Map<String, Map<String, String>> languages = await di.init();
  // request permission for firebase messaging
  FirebaseMessaging.instance.requestPermission();
  // initialize notification
  NotificationHelper.initialize();
  // initialize google mobile ads
  await MobileAds.instance.initialize();
  // Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    if (error.toString().contains('HttpException: Invalid statusCode: 404')) {
      return false;
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    }
  };
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({required this.languages, super.key});

  @override
  Widget build(BuildContext context) {
    // Example criteria for device type detection
    final bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final bool isLargeTablet = MediaQuery.of(context).size.shortestSide > 800;
    // Define designSizes for different devices
    Size designSize;
    if (isLargeTablet) {
      designSize = const Size(1024, 1366); // Example for large tablets
    } else if (isTablet) {
      designSize = const Size(768, 1024); // Example for regular tablets
    } else {
      designSize = const Size(411.4, 866.3); // Example for phones
    }
    return GetBuilder<LocalizationController>(builder: (localizeController) {
      return GetBuilder<ThemeController>(
        builder: (themeController) {
          return ScreenUtilInit(
            designSize: designSize,
            minTextAdapt: true,
            splitScreenMode: true,
            fontSizeResolver: (size, util) => _screenSize(size, isTablet, isLargeTablet, util),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.0)),
              ),
              child: GetMaterialApp(
                title: AppConstants.APP_NAME,
                debugShowCheckedModeBanner: false,
                themeMode: themeController.themeMode,
                theme: light(context),
                darkTheme: dark(context),
                locale: localizeController.locale,
                translations: Messages(languages: languages),
                fallbackLocale: Locale(
                  AppConstants.languages[0].languageCode,
                  AppConstants.languages[0].countryCode,
                ),
                navigatorObservers: [FlutterSmartDialog.observer],
                builder: FlutterSmartDialog.init(
                  loadingBuilder: (string) => const LoadingWidget(),
                  builder: (context, child) {
                    return ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: child ?? const SizedBox(),
                    );
                  },
                ),
                home: UpgradeAlert(
                  dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
                  child: const Root(),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  double _screenSize(size, isTablet, isLargeTablet, util) {
    double scaleFactor = 1.0;
    if (isTablet || isLargeTablet) {
      scaleFactor = 1.0;
    } else {
      scaleFactor = util.scaleText;
    }
    return size * scaleFactor;
  }
}

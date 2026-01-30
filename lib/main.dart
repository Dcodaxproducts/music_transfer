import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';
import 'core/theme/design_helper.dart';
import 'core/theme/light_theme.dart';
import 'core/widgets/loading.dart';
import 'firebase_options.dart';
import 'core/helper/notification_helper.dart';
import 'core/theme/dark_theme.dart';
import 'core/utils/messages.dart';
import 'core/helper/get_di.dart' as di;
import 'features/splash/presentation/view/root.dart';
import 'imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(MyApp(languages: await di.init()));
}

Future<void> _initializeApp() async {
  // Disable landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize notification
  NotificationHelper.initialize();

  // Initialize ad network (do not wait for it)
  _initializeAdNetwork();

  // Initialize Crashlytics
  _initCrashlytics();
}

Future<void> _initializeAdNetwork() async {
  await MobileAds.instance.initialize();
}

void _initCrashlytics() {
  // Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({required this.languages, super.key});

  @override
  Widget build(BuildContext context) {
    final Size designSize = DesignHelper.getDesignSize(context);
    final bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    final bool isLargeTablet = MediaQuery.of(context).size.shortestSide > 800;
    return GetBuilder<LocalizationController>(
      builder: (localizeController) {
        return GetBuilder<ThemeController>(
          builder: (themeController) {
            return ScreenUtilInit(
              designSize: designSize,
              minTextAdapt: true,
              splitScreenMode: true,
              fontSizeResolver: (num size, ScreenUtil util) {
                return DesignHelper.screenSize(size, isTablet, isLargeTablet, util);
              },
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.0)),
                ),
                child: GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  themeMode: themeController.themeMode,
                  theme: light,
                  darkTheme: dark,
                  locale: localizeController.locale,
                  translations: Messages(languages: languages),
                  fallbackLocale: Locale(appLanguages[0].languageCode, appLanguages[0].countryCode),
                  navigatorObservers: [FlutterSmartDialog.observer],
                  builder: FlutterSmartDialog.init(loadingBuilder: (string) => const LoadingWidget()),
                  home: UpgradeAlert(
                    dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
                    showIgnore: false,
                    showLater: false,
                    barrierDismissible: false,
                    child: const Root(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

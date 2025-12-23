import 'package:flutter/services.dart';
import 'package:pixart_app/imports.dart';

class PrimarySafeArea extends StatelessWidget {
  final Widget child;
  const PrimarySafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: GetPlatform.isAndroid ? true : false,
      child: child,
    );
  }
}

class PrimaryAnnotatedRegion extends StatelessWidget {
  final Widget child;
  const PrimaryAnnotatedRegion({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: context.theme.scaffoldBackgroundColor,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: context.isDarkMode
            ? Brightness.dark
            : Brightness.light,
      ),
      child: child,
    );
  }
}

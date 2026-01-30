import 'revenuecat_constants.dart';

class RevenueCatConfig {
  final String iosApiKey;
  final String androidApiKey;
  const RevenueCatConfig({required this.iosApiKey, required this.androidApiKey});

  static RevenueCatConfig get defaultConfig {
    if (RevenueCatConstants.useSandboxInDebug) {
      return const RevenueCatConfig(
        iosApiKey: RevenueCatConstants.iosTestKey,
        androidApiKey: RevenueCatConstants.androidTestKey,
      );
    }
    return const RevenueCatConfig(
      iosApiKey: RevenueCatConstants.iosLiveApiKey,
      androidApiKey: RevenueCatConstants.androidLiveApiKey,
    );
  }
}

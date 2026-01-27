import 'revenuecat_constants.dart';

/// Configuration model for RevenueCat
class RevenueCatConfig {
  /// RevenueCat API key for iOS
  final String iosApiKey;

  /// RevenueCat API key for Android
  final String androidApiKey;

  const RevenueCatConfig({required this.iosApiKey, required this.androidApiKey});

  /// Default configuration for Vynox VPN
  static RevenueCatConfig get defaultConfig => const RevenueCatConfig(
    iosApiKey: RevenueCatConstants.iosApiKey,
    androidApiKey: RevenueCatConstants.androidApiKey,
  );

  /// Copy with method for creating modified configurations
  RevenueCatConfig copyWith({
    String? iosApiKey,
    String? androidApiKey,
    String? premiumEntitlementId,
    bool? useSandbox,
    String? appUserId,
  }) {
    return RevenueCatConfig(
      iosApiKey: iosApiKey ?? this.iosApiKey,
      androidApiKey: androidApiKey ?? this.androidApiKey,
    );
  }

  @override
  String toString() {
    return 'RevenueCatConfig(iosApiKey: ${iosApiKey.substring(0, 8)}..., '
        'androidApiKey: ${androidApiKey.substring(0, 8)}...)';
  }
}

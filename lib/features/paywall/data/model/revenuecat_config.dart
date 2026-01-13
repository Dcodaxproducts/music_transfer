import 'revenuecat_constants.dart';

/// Configuration model for RevenueCat
class RevenueCatConfig {
  /// RevenueCat API key for iOS
  final String iosApiKey;

  /// RevenueCat API key for Android
  final String androidApiKey;

  /// Primary entitlement identifier for premium features
  final String premiumEntitlementId;

  /// App user ID (optional, RevenueCat will generate one if not provided)
  final String? appUserId;

  const RevenueCatConfig({
    required this.iosApiKey,
    required this.androidApiKey,
    required this.premiumEntitlementId,
    this.appUserId,
  });

  /// Default configuration for Vynox VPN
  static RevenueCatConfig get defaultConfig => const RevenueCatConfig(
    iosApiKey: RevenueCatConstants.iosApiKey,
    androidApiKey: RevenueCatConstants.androidApiKey,
    premiumEntitlementId: RevenueCatConstants.premiumEntitlementId,
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
      premiumEntitlementId: premiumEntitlementId ?? this.premiumEntitlementId,
      appUserId: appUserId ?? this.appUserId,
    );
  }

  @override
  String toString() {
    return 'RevenueCatConfig(iosApiKey: ${iosApiKey.substring(0, 8)}..., '
        'androidApiKey: ${androidApiKey.substring(0, 8)}..., '
        'premiumEntitlementId: $premiumEntitlementId, '
        'appUserId: $appUserId)';
  }
}

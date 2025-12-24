/// Constants for RevenueCat configuration
class RevenueCatConstants {
  /// RevenueCat API Keys
  static const String iosApiKey = 'appl_cYkFvzJGqCHAYoBiXcMWnYLDBDo';
  static const String androidApiKey = 'goog_xXdPPDzoEwGrhOAbfFIwfFqEkUV';

  /// Entitlement identifiers
  /// These should match the entitlements configured in RevenueCat dashboard
  static const String premiumEntitlementId = 'premium';

  /// Environment settings
  static const bool useSandboxInDebug = true;
  static const bool enableDebugLogsInDebug = true;

  /// Private constructor to prevent instantiation
  RevenueCatConstants._();
}

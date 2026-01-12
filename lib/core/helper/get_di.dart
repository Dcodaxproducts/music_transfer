import 'dart:convert';
import 'package:pixart_app/features/ads/domain/binding/ads_binding.dart';
import 'package:pixart_app/features/dashboard/domain/binding/dashboard_binding.dart';
import 'package:pixart_app/image_gen/history/domain/binding/history_binding.dart';
import 'package:pixart_app/image_gen/home/domain/binding/image_generation_bindings.dart';
import 'package:pixart_app/image_gen/inspirations/domain/binding/inspiration_binding.dart';
import 'package:pixart_app/features/language/domain/binding/language_binding.dart';
import 'package:pixart_app/features/review/domain/binding/review_binding.dart';
import 'package:pixart_app/features/splash/domain/binding/splash_binding.dart';
import 'package:pixart_app/features/tools/domain/binding/tools_binding.dart';
import 'package:pixart_app/core/api/api_client_impl.dart';
import 'package:flutter/services.dart';
import '../../features/auth/domain/binding/auth_binding.dart';
import '../../features/paywall/domain/binding/subscription_binding.dart';
import '../../imports.dart';
import '../../image_gen/home/domain/binding/models_binding.dart';
import '../../features/theme/domain/binding/theme_binding.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences, fenix: true);
  ApiClient apiClient = ApiClientImpl(baseUrl: Endpoints.baseUrl);
  Get.lazyPut(() => apiClient, fenix: true);

  final List<Bindings> bindings = [
    DashboardBinding(),
    ThemeBinding(),
    LanguageBinding(),
    AdsBinding(),
    ModelsBinding(),
    ImageGenerationBindings(),
    HistoryBinding(),
    SplashBinding(),
    ModelsBinding(),
    InspirationBinding(),
    ReviewBinding(),
    ToolsBinding(),
    SubscriptionBinding(),
    AuthBinding(),
  ];

  for (Bindings binding in bindings) {
    binding.dependencies();
  }

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in appLanguages) {
    String jsonStringValues = await rootBundle.loadString(
      'assets/language/${languageModel.languageCode}.json',
    );
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}

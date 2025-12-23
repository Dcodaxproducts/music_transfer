import 'dart:convert';
import 'package:pixart_app/features/ads/domain/binding/ads_binding.dart';
import 'package:pixart_app/modules/bg_remover/domain/binding/background_remover_bindings.dart';
import 'package:pixart_app/features/dashboard/domain/binding/dashboard_binding.dart';
import 'package:pixart_app/modules/image_generation/history/domain/binding/history_binding.dart';
import 'package:pixart_app/modules/image_generation/home/domain/binding/image_generation_bindings.dart';
import 'package:pixart_app/modules/image_generation/inspirations/domain/binding/inspiration_binding.dart';
import 'package:pixart_app/features/language/domain/binding/language_binding.dart';
import 'package:pixart_app/features/review/domain/binding/review_binding.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/domain/binding/setting_binding.dart';
import 'package:pixart_app/features/subscription/domain/binding/subscription_binding.dart';
import 'package:pixart_app/features/tools/domain/binding/tools_binding.dart';
import 'package:pixart_app/core/api/api_client_impl.dart';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../imports.dart';
import '../../modules/image_generation/home/domain/binding/generation_binding.dart';
import '../../modules/image_generation/models/domain/binding/models_binding.dart';
import '../../features/theme/domain/binding/theme_binding.dart';
import '../../modules/image_upscale/domain/binding/upscale_binding.dart';

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
    GenerationBinding(),
    HistoryBinding(),
    SettingBinding(),
    ModelsBinding(),
    InspirationBinding(),
    ReviewBinding(),
    UpscaleBinding(),
    BackgroundRemoverBindings(),
    ToolsBinding(),
    SubscriptionBinding(),
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
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }
  return languages;
}

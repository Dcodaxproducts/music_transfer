import 'dart:convert';
import 'package:matrix_ai/features/ads/domain/binding/ads_binding.dart';
import 'package:matrix_ai/features/aws/domain/binding/aws_binding.dart';
import 'package:matrix_ai/features/background_remover/domain/binding/background_remover_bindings.dart';
import 'package:matrix_ai/features/dashboard/domain/binding/dashboard_binding.dart';
import 'package:matrix_ai/features/history/domain/binding/history_binding.dart';
import 'package:matrix_ai/features/home/domain/binding/image_generation_bindings.dart';
import 'package:matrix_ai/features/inspirations/domain/binding/inspiration_binding.dart';
import 'package:matrix_ai/features/language/domain/binding/language_binding.dart';
import 'package:matrix_ai/features/review/domain/binding/review_binding.dart';
import 'package:matrix_ai/features/prompt_setting/domain/binding/setting_binding.dart';
import 'package:matrix_ai/features/subscription/domain/binding/subscription_binding.dart';
import 'package:matrix_ai/features/tools/domain/binding/tools_binding.dart';
import 'package:matrix_ai/core/api/api_client.dart';
import 'package:matrix_ai/core/api/api_client_interface.dart';
import 'package:matrix_ai/features/language/data/model/language.dart';
import 'package:matrix_ai/core/utils/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../features/home/domain/binding/generation_binding.dart';
import '../../features/image_generation_result/domain/binding/binding.dart';
import '../../features/models/domain/binding/models_binding.dart';
import '../../features/theme/domain/binding/theme_binding.dart';
import '../../features/upscale_image/domain/binding/upscale_binding.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences, fenix: true);
  ApiClientInterface apiClient = ApiClient(prefs: Get.find());
  Get.lazyPut(() => apiClient, fenix: true);

  final List<Bindings> bindings = [
    DashboardBinding(),
    ThemeBinding(),
    LanguageBinding(),
    AdsBinding(),
    AwsBinding(),
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
    ImageGenerationResultBinding(),
  ];

  for (Bindings binding in bindings) {
    binding.dependencies();
  }

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =
        await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}

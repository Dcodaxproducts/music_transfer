import 'dart:convert';
import 'package:matrix_ai/controller/ads_controller.dart';
import 'package:matrix_ai/controller/api_controller.dart';
import 'package:matrix_ai/controller/generation_controller.dart';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:matrix_ai/controller/inspiration_controller.dart';
import 'package:matrix_ai/controller/models_controller.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/controller/localization_controller.dart';
import 'package:matrix_ai/controller/subscription_controller.dart';
import 'package:matrix_ai/controller/theme_controller.dart';
import 'package:matrix_ai/controller/update_controller.dart';
import 'package:matrix_ai/data/api/api_client.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:matrix_ai/data/model/language.dart';
import 'package:matrix_ai/data/repository/image_generation_repo.dart';
import 'package:matrix_ai/data/repository/history_repo.dart';
import 'package:matrix_ai/data/repository/inspiration_repo.dart';
import 'package:matrix_ai/data/repository/language_repo.dart';
import 'package:matrix_ai/data/repository/models_repo.dart';
import 'package:matrix_ai/data/repository/settings_repo.dart';
import 'package:matrix_ai/data/repository/settings_repo_interface.dart';
import 'package:matrix_ai/data/service/setting_service.dart';
import 'package:matrix_ai/data/service/setting_service_interface.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../data/repository/image_generation_repo_interface.dart';
import '../data/service/image_generation_service.dart';
import '../data/service/image_generation_service_interface.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  ApiClientInterface apiClient = ApiClient(sharedPreferences: Get.find());
  Get.lazyPut(() => apiClient);

  // Repository
  ImageGenerationRepoInterface imageGenerationRepo =
      ImageGenerationRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => imageGenerationRepo);
  SettingsRepoInterface settingsRepo =
      SettingsRepo(sharedPreferences: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => settingsRepo);
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(
      () => ModelsRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => HistoryRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      InspirationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Service
  ImageGenerationServiceInterface imageGenerationService =
      ImageGenerationService(imageGenerationRepo: Get.find());
  Get.lazyPut(() => imageGenerationService);
  SettingsServiceInterface settingsService =
      SettingsService(settingsRepo: Get.find());
  Get.lazyPut(() => settingsService);

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SetttingsController(settingsService: Get.find()));
  Get.lazyPut(() =>
      ImageGenerationController(imageGenerationServiceInterface: Get.find()));
  Get.lazyPut(() => AdsController());
  Get.lazyPut(() => SubscriptionController());
  Get.lazyPut(() => ModelsController(modelsRepo: Get.find()));
  Get.lazyPut(() => HistoryController(historyRepo: Get.find()));
  Get.lazyPut(() => InspirationController(inspirationRepo: Get.find()));
  Get.lazyPut(() => UpdateController());
  Get.lazyPut(() => GenerationController());

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
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

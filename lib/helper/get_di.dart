import 'dart:convert';
import 'package:matrix_ai/controller/ads_controller.dart';
import 'package:matrix_ai/controller/dashboard_controller.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
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
import 'package:matrix_ai/data/repository/history_repo_interface.dart';
import 'package:matrix_ai/data/repository/image_generation_repo.dart';
import 'package:matrix_ai/data/repository/history_repo.dart';
import 'package:matrix_ai/data/repository/inspiration_repo.dart';
import 'package:matrix_ai/data/repository/language_repo.dart';
import 'package:matrix_ai/data/repository/models_repo.dart';
import 'package:matrix_ai/data/repository/settings_repo.dart';
import 'package:matrix_ai/data/repository/settings_repo_interface.dart';
import 'package:matrix_ai/data/service/ads_service.dart';
import 'package:matrix_ai/data/service/ads_service_interface.dart';
import 'package:matrix_ai/data/service/history_service_interface.dart';
import 'package:matrix_ai/data/service/inspiration_service_interface.dart';
import 'package:matrix_ai/data/service/localization_service.dart';
import 'package:matrix_ai/data/service/localization_service_interface.dart';
import 'package:matrix_ai/data/service/model_service_interface.dart';
import 'package:matrix_ai/data/service/setting_service.dart';
import 'package:matrix_ai/data/service/setting_service_interface.dart';
import 'package:matrix_ai/data/service/subscription_service_interface.dart';
import 'package:matrix_ai/data/service/theme_service_interface.dart';
import 'package:matrix_ai/data/service/update_service.dart';
import 'package:matrix_ai/data/service/update_service_interface.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../data/repository/image_generation_repo_interface.dart';
import '../data/repository/inspiration_repo_interface.dart';
import '../data/repository/models_repo_interface.dart';
import '../data/service/history_service.dart';
import '../data/service/image_generation_service.dart';
import '../data/service/image_generation_service_interface.dart';
import '../data/service/inspiration_service.dart';
import '../data/service/model_service.dart';
import '../data/service/subscription_service.dart';
import '../data/service/theme_service.dart';

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
  ModelsRepoInterface modelsRepoInterface =
      ModelsRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => modelsRepoInterface);
  HistoryRepoInteraface historyRepoInteraface =
      HistoryRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => historyRepoInteraface);
  InspirationRepoInterface inspirationRepoInterface =
      InspirationRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => inspirationRepoInterface);
  SettingsRepoInterface settingsRepoInterface =
      SettingsRepo(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => settingsRepoInterface);

  // Service
  ImageGenerationServiceInterface imageGenerationService =
      ImageGenerationService(imageGenerationRepo: Get.find());
  Get.lazyPut(() => imageGenerationService);
  SettingsServiceInterface settingsService =
      SettingsService(settingsRepo: Get.find());
  Get.lazyPut(() => settingsService);
  UpdateServiceInterface updateServiceInterface = UpdateService();
  Get.lazyPut(() => updateServiceInterface);
  AdsServiceInterface adsServiceInterface = AdsService();
  Get.lazyPut(() => adsServiceInterface);
  HistoryServiceInterface historyService =
      HistoryService(historyRepo: Get.find());
  Get.lazyPut(() => historyService);
  InspirationServiceInterface inspirationServiceInterface =
      InspirationService(inspirationRepo: Get.find());
  Get.lazyPut(() => inspirationServiceInterface);
  ModelsServiceInterface modelsServiceInterface =
      ModelsService(modelsRepo: Get.find());
  Get.lazyPut(() => modelsServiceInterface);
  ThemeServiceInterface themeServiceInterface =
      ThemeService(sharedPreferences: Get.find());
  Get.lazyPut(() => themeServiceInterface);
  SubscriptionServiceInterface subscriptionServiceInterface =
      SubscriptionService();
  Get.lazyPut(() => subscriptionServiceInterface);
  LocalizationServiceInterface localizationServiceInterface =
      LocalizationService(sharedPreferences: Get.find());
  Get.lazyPut(() => localizationServiceInterface);
  SettingsServiceInterface settingsServiceInterface =
      SettingsService(settingsRepo: Get.find());
  Get.lazyPut(() => settingsServiceInterface);

  // Controller
  Get.lazyPut(() => ThemeController(themeService: Get.find()));
  Get.lazyPut(() => LocalizationController(localizationService: Get.find()));
  Get.lazyPut(() => SettingsController(settingsService: Get.find()));
  Get.lazyPut(() =>
      ImageGenerationController(imageGenerationServiceInterface: Get.find()));
  Get.lazyPut(() => AdsController(adsService: Get.find()));
  Get.lazyPut(() => SubscriptionController(subscriptionService: Get.find()));
  Get.lazyPut(() => ModelsController(modelsService: Get.find()));
  Get.lazyPut(() => HistoryController(historyService: Get.find()));
  Get.lazyPut(() => InspirationController(inspirationService: Get.find()));
  Get.lazyPut(() => UpdateController(updateService: Get.find()));
  Get.lazyPut(() => GenerationController());
  Get.lazyPut(() => DashboardController());
  Get.lazyPut(() => SettingsController(settingsService: Get.find()));

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

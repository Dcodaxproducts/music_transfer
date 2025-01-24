import 'dart:convert';
import 'package:matrix_ai/controller/ads_controller.dart';
import 'package:matrix_ai/controller/dashboard_controller.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/controller/generation_controller.dart';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:matrix_ai/controller/inspiration_controller.dart';
import 'package:matrix_ai/controller/models_controller.dart';
import 'package:matrix_ai/controller/review_controller.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/controller/localization_controller.dart';
import 'package:matrix_ai/controller/subscription_controller.dart';
import 'package:matrix_ai/controller/theme_controller.dart';
import 'package:matrix_ai/controller/tools_controller.dart';
import 'package:matrix_ai/controller/upscale_image_queue_controller.dart';
import 'package:matrix_ai/data/api/api_client.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:matrix_ai/data/model/language.dart';
import 'package:matrix_ai/data/repository/ad_repo.dart';
import 'package:matrix_ai/data/repository/ad_repo_interface.dart';
import 'package:matrix_ai/data/repository/background_remover_repo_interface.dart';
import 'package:matrix_ai/data/repository/generation_repo.dart';
import 'package:matrix_ai/data/repository/generation_repo_interface.dart';
import 'package:matrix_ai/data/repository/history_repo_interface.dart';
import 'package:matrix_ai/data/repository/image_generation_repo.dart';
import 'package:matrix_ai/data/repository/history_repo.dart';
import 'package:matrix_ai/data/repository/image_upscale_repo_interface.dart';
import 'package:matrix_ai/data/repository/inspiration_repo.dart';
import 'package:matrix_ai/data/repository/language_repo.dart';
import 'package:matrix_ai/data/repository/models_repo.dart';
import 'package:matrix_ai/data/repository/review_repo_interface.dart';
import 'package:matrix_ai/data/repository/settings_repo.dart';
import 'package:matrix_ai/data/repository/settings_repo_interface.dart';
import 'package:matrix_ai/data/repository/tools_repo_interface.dart';
import 'package:matrix_ai/data/service/ads_service.dart';
import 'package:matrix_ai/data/service/ads_service_interface.dart';
import 'package:matrix_ai/data/service/aws_service_intereface.dart';
import 'package:matrix_ai/data/service/generation_service.dart';
import 'package:matrix_ai/data/service/generation_service_interface.dart';
import 'package:matrix_ai/data/service/history_service_interface.dart';
import 'package:matrix_ai/data/service/inspiration_service_interface.dart';
import 'package:matrix_ai/data/service/localization_service.dart';
import 'package:matrix_ai/data/service/localization_service_interface.dart';
import 'package:matrix_ai/data/service/model_service_interface.dart';
import 'package:matrix_ai/data/service/review_service.dart';
import 'package:matrix_ai/data/service/review_service_interface.dart';
import 'package:matrix_ai/data/service/setting_service.dart';
import 'package:matrix_ai/data/service/setting_service_interface.dart';
import 'package:matrix_ai/data/service/subscription_service_interface.dart';
import 'package:matrix_ai/data/service/theme_service_interface.dart';
import 'package:matrix_ai/data/service/tools_service.dart';
import 'package:matrix_ai/data/service/tools_service_interface.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../controller/aws_controller.dart';
import '../controller/background_remover_controller.dart';
import '../controller/image_upscale_controller.dart';
import '../controller/queue_controller.dart';
import '../data/repository/background_remover_repo.dart';
import '../data/repository/image_generation_repo_interface.dart';
import '../data/repository/image_upscale_repo.dart';
import '../data/repository/inspiration_repo_interface.dart';
import '../data/repository/models_repo_interface.dart';
import '../data/repository/review_repo.dart';
import '../data/repository/tools_repo.dart';
import '../data/service/aws_service.dart';
import '../data/service/background_remover_service.dart';
import '../data/service/background_remover_service_interface.dart';
import '../data/service/history_service.dart';
import '../data/service/image_generation_service.dart';
import '../data/service/image_generation_service_interface.dart';
import '../data/service/image_upscale_service.dart';
import '../data/service/image_upscale_service_interface.dart';
import '../data/service/inspiration_service.dart';
import '../data/service/model_service.dart';
import '../data/service/subscription_service.dart';
import '../data/service/theme_service.dart';
import 'package:easy_audience_network/easy_audience_network.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences, fenix: true);
  ApiClientInterface apiClient = ApiClient(prefs: Get.find());
  Get.lazyPut(() => apiClient, fenix: true);
  if (GetPlatform.isAndroid) {
    await EasyAudienceNetwork.init(testingId: '4fbcc06a-ce20-488e-a177-548ef22109c3');
  }

  // Repository
  ImageGenerationRepoInterface imageGenerationRepo =
      ImageGenerationRepo(apiClient: Get.find(), prefs: Get.find());
  Get.lazyPut(() => imageGenerationRepo, fenix: true);
  SettingsRepoInterface settingsRepo = SettingsRepo(prefs: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => settingsRepo, fenix: true);
  Get.lazyPut(() => LanguageRepo(), fenix: true);
  ModelsRepoInterface modelsRepoInterface = ModelsRepo(apiClient: Get.find(), prefs: Get.find());
  Get.lazyPut(() => modelsRepoInterface, fenix: true);
  HistoryRepoInteraface historyRepoInteraface = HistoryRepo(apiClient: Get.find(), prefs: Get.find());
  Get.lazyPut(() => historyRepoInteraface, fenix: true);
  InspirationRepoInterface inspirationRepoInterface =
      InspirationRepo(apiClient: Get.find(), prefs: Get.find());
  Get.lazyPut(() => inspirationRepoInterface, fenix: true);
  SettingsRepoInterface settingsRepoInterface = SettingsRepo(apiClient: Get.find(), prefs: Get.find());
  Get.lazyPut(() => settingsRepoInterface, fenix: true);
  AdRepoInterface adRepoInterface = AdRepo(apiClient: Get.find());
  Get.lazyPut(() => adRepoInterface, fenix: true);
  GenerationRepoInterface generationRepoInterface = GenerationRepo(prefs: Get.find());
  Get.lazyPut(() => generationRepoInterface, fenix: true);
  ReviewRepoInterface reviewRepoInterface = ReviewRepo(prefs: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => reviewRepoInterface, fenix: true);
  ImageUpscaleRepoInterface imageUpscaleRepoInterface =
      ImageUpscaleRepo(prefs: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => imageUpscaleRepoInterface, fenix: true);
  BackgroundRemoverRepoInterface backgroundRemoverRepoInterface =
      BackgroundRemoverRepo(prefs: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => backgroundRemoverRepoInterface, fenix: true);
  ToolsRepoInterface toolsRepoInterface = ToolsRepo(apiClient: Get.find());
  Get.lazyPut(() => toolsRepoInterface, fenix: true);

  // Service
  ImageGenerationServiceInterface imageGenerationService =
      ImageGenerationService(imageGenerationRepo: Get.find());
  Get.lazyPut(() => imageGenerationService, fenix: true);
  SettingsServiceInterface settingsService = SettingsService(settingsRepo: Get.find());
  Get.lazyPut(() => settingsService, fenix: true);
  AdsServiceInterface adsServiceInterface = AdsService(adRepo: Get.find());
  Get.lazyPut(() => adsServiceInterface, fenix: true);
  HistoryServiceInterface historyService = HistoryService(historyRepo: Get.find());
  Get.lazyPut(() => historyService, fenix: true);
  InspirationServiceInterface inspirationServiceInterface = InspirationService(inspirationRepo: Get.find());
  Get.lazyPut(() => inspirationServiceInterface, fenix: true);
  ModelsServiceInterface modelsServiceInterface = ModelsService(modelsRepo: Get.find());
  Get.lazyPut(() => modelsServiceInterface, fenix: true);
  ThemeServiceInterface themeServiceInterface = ThemeService(sharedPreferences: Get.find());
  Get.lazyPut(() => themeServiceInterface, fenix: true);
  SubscriptionServiceInterface subscriptionServiceInterface = SubscriptionService();
  Get.lazyPut(() => subscriptionServiceInterface, fenix: true);
  LocalizationServiceInterface localizationServiceInterface =
      LocalizationService(sharedPreferences: Get.find());
  Get.lazyPut(() => localizationServiceInterface, fenix: true);
  SettingsServiceInterface settingsServiceInterface = SettingsService(settingsRepo: Get.find());
  Get.lazyPut(() => settingsServiceInterface, fenix: true);
  GenerationServiceInterface generationServiceInterface =
      GenerationService(generationRepoInterface: Get.find());
  Get.lazyPut(() => generationServiceInterface, fenix: true);
  ReviewServiceInterface reviewServiceInterface = ReviewService(reviewRepo: Get.find());
  Get.lazyPut(() => reviewServiceInterface, fenix: true);
  ImageUpscaleServiceInterface imageUpscaleServiceInterface =
      ImageUpscaleService(imageUpscaleRepo: Get.find());
  Get.lazyPut(() => imageUpscaleServiceInterface, fenix: true);
  BackgroundRemoverServiceInterface backgroundRemoverServiceInterface =
      BackgroundRemoverService(backgroundRemoverRepo: Get.find());
  Get.lazyPut(() => backgroundRemoverServiceInterface, fenix: true);
  ToolsServiceInterface toolsServiceInterface = ToolsService(toolsRepo: Get.find());
  Get.lazyPut(() => toolsServiceInterface, fenix: true);
  AwsServiceInterface awsServiceInterface = AwsService(apiClient: Get.find());
  Get.lazyPut(() => awsServiceInterface, fenix: true);

  // Controller
  Get.lazyPut(() => ThemeController(themeService: Get.find()), fenix: true);
  Get.lazyPut(() => LocalizationController(localizationService: Get.find()), fenix: true);
  Get.lazyPut(() => SettingsController(settingsService: Get.find()), fenix: true);
  Get.lazyPut(() => ImageGenerationController(imageGenerationServiceInterface: Get.find()), fenix: true);
  Get.lazyPut(() => AdsController(adsService: Get.find()), fenix: true);
  Get.lazyPut(() => SubscriptionController(subscriptionService: Get.find()), fenix: true);
  Get.lazyPut(() => ModelsController(modelsService: Get.find()), fenix: true);
  Get.lazyPut(() => HistoryController(historyService: Get.find()), fenix: true);
  Get.lazyPut(() => InspirationController(inspirationService: Get.find()), fenix: true);
  Get.lazyPut(() => GenerationController(generationServiceInterface: Get.find()), fenix: true);
  Get.lazyPut(() => DashboardController(), fenix: true);
  Get.lazyPut(() => SettingsController(settingsService: Get.find()), fenix: true);
  Get.lazyPut(() => QueueController(), fenix: true);
  Get.lazyPut(() => ReviewController(reviewService: Get.find()), fenix: true);
  Get.lazyPut(() => ImageUpscaleController(imageUpscaleService: Get.find()), fenix: true);
  Get.lazyPut(() => BackgroundRemoverController(backgroundRemoverService: Get.find()), fenix: true);
  Get.lazyPut(() => ToolsController(toolsService: Get.find()), fenix: true);
  Get.lazyPut(() => UpscaleImageQueueController(), fenix: true);
  Get.lazyPut(() => AwsController(awsService: Get.find()), fenix: true);

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

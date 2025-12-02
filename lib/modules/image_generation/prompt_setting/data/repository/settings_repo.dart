import 'dart:convert';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/data/model/config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../imports.dart';
import '../../../models/data/model/model.dart';
import 'settings_repo_interface.dart';

class SettingsRepo implements SettingsRepoInterface {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  SettingsRepo({required this.prefs, required this.apiClient});

  @override
  ConfigModel initSharedData() {
    // negative prompt
    String negativePrompt = prefs.getString(SharedKeys.NEGATIVE_PROMPT) ?? '';

    // guidance scale
    double guidanceScale = prefs.getDouble(SharedKeys.GUIDANCE_SCALE) ?? 3.5;

    // aspect ratio
    int aspectRatio = prefs.getInt(SharedKeys.ASPECT_RATIO) ?? 1;

    // selected model
    String? model = prefs.getString(SharedKeys.SELECTED_MODEL);
    Model? selectedModel;
    if (model != null) {
      selectedModel = Model.fromJson(jsonDecode(model));
    }

    // has viewed ads dialog
    bool hasViewedAdsDialog = prefs.getBool(SharedKeys.HAS_VIEWED_ADS_DIALOG) ?? false;

    // onboarding skip
    bool onBoardingSkip = prefs.getBool(SharedKeys.ON_BOARDING_SKIP) ?? false;

    // notification enabled
    bool notificationEnabled = prefs.getBool(SharedKeys.NOTIFICATION) ?? false;

    // check if the theme, language and country code are set
    if (!prefs.containsKey(SharedKeys.THEME)) {
      prefs.setString(SharedKeys.THEME, 'system');
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(SharedKeys.COUNTRY_CODE)) {
      prefs.setString(SharedKeys.COUNTRY_CODE, appLanguages[0].countryCode);
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(SharedKeys.LANGUAGE_CODE)) {
      prefs.setString(SharedKeys.LANGUAGE_CODE, appLanguages[0].languageCode);
    }

    return ConfigModel(
      onBoardingSkip: onBoardingSkip,
      guidanceScale: guidanceScale,
      aspectRatio: aspectRatio,
      selectedModel: selectedModel,
      negativePrompt: negativePrompt,
      notificationsEnabled: notificationEnabled,
      hasViewdAdsDialog: hasViewedAdsDialog,
    );
  }

  @override
  Future<void> updateSharedData(ConfigModel configModel) async {
    await Future.wait([
      prefs.setDouble(SharedKeys.GUIDANCE_SCALE, configModel.guidanceScale),
      prefs.setInt(SharedKeys.ASPECT_RATIO, configModel.aspectRatio),
      prefs.setString(SharedKeys.SELECTED_MODEL, jsonEncode(configModel.selectedModel?.toJson())),
      prefs.setString(SharedKeys.NEGATIVE_PROMPT, configModel.negativePrompt),
      prefs.setBool(SharedKeys.ON_BOARDING_SKIP, configModel.onBoardingSkip),
      prefs.setBool(SharedKeys.NOTIFICATION, configModel.notificationsEnabled),
      prefs.setBool(SharedKeys.HAS_VIEWED_ADS_DIALOG, configModel.hasViewdAdsDialog),
    ]);
  }

  @override
  Future<Response?> getConfig() async => await apiClient.get(Endpoints.CONFIG_URL);

  @override
  int getOpenCount() {
    int openCount = prefs.getInt(SharedKeys.OPEN_COUNT) ?? 0;
    openCount++;
    prefs.setInt(SharedKeys.OPEN_COUNT, openCount);
    return openCount;
  }

  @override
  Future<bool> saveFirstTime() async => await prefs.setBool(SharedKeys.ON_BOARDING_SKIP, false);

  @override
  bool getFirstTime() => prefs.getBool(SharedKeys.ON_BOARDING_SKIP) ?? true;

  @override
  Future<bool> saveShowAppOpen() async => await prefs.setBool(SharedKeys.SHOW_APP_OPEN, true);

  @override
  bool getShowAppOpen() => prefs.getBool(SharedKeys.SHOW_APP_OPEN) ?? false;
}

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
    String negativePrompt = prefs.getString(SharedKeys.negativePrompt) ?? '';

    // guidance scale
    double guidanceScale = prefs.getDouble(SharedKeys.guidanceScale) ?? 3.5;

    // aspect ratio
    int aspectRatio = prefs.getInt(SharedKeys.aspectRatio) ?? 1;

    // selected model
    String? model = prefs.getString(SharedKeys.selectedModel);
    Model? selectedModel;
    if (model != null) {
      selectedModel = Model.fromJson(jsonDecode(model));
    }

    // has viewed ads dialog
    bool hasViewedAdsDialog =
        prefs.getBool(SharedKeys.hasViewedAdsDialog) ?? false;

    // onboarding skip
    bool onBoardingSkip = prefs.getBool(SharedKeys.onBoardingSkip) ?? false;

    // notification enabled
    bool notificationEnabled = prefs.getBool(SharedKeys.notification) ?? false;

    // check if the theme, language and country code are set
    if (!prefs.containsKey(SharedKeys.theme)) {
      prefs.setString(SharedKeys.theme, 'system');
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(SharedKeys.countryCode)) {
      prefs.setString(SharedKeys.countryCode, appLanguages[0].countryCode);
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(SharedKeys.languageCode)) {
      prefs.setString(SharedKeys.languageCode, appLanguages[0].languageCode);
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
      prefs.setDouble(SharedKeys.guidanceScale, configModel.guidanceScale),
      prefs.setInt(SharedKeys.aspectRatio, configModel.aspectRatio),
      prefs.setString(
        SharedKeys.selectedModel,
        jsonEncode(configModel.selectedModel?.toJson()),
      ),
      prefs.setString(SharedKeys.negativePrompt, configModel.negativePrompt),
      prefs.setBool(SharedKeys.onBoardingSkip, configModel.onBoardingSkip),
      prefs.setBool(SharedKeys.notification, configModel.notificationsEnabled),
      prefs.setBool(
        SharedKeys.hasViewedAdsDialog,
        configModel.hasViewdAdsDialog,
      ),
    ]);
  }

  @override
  Future<Response?> getConfig() async =>
      await apiClient.get(Endpoints.CONFIG_URL);

  @override
  int getOpenCount() {
    int openCount = prefs.getInt(SharedKeys.openCount) ?? 0;
    openCount++;
    prefs.setInt(SharedKeys.openCount, openCount);
    return openCount;
  }

  @override
  Future<bool> saveFirstTime() async =>
      await prefs.setBool(SharedKeys.onBoardingSkip, false);

  @override
  bool getFirstTime() => prefs.getBool(SharedKeys.onBoardingSkip) ?? true;

  @override
  Future<bool> saveShowAppOpen() async =>
      await prefs.setBool(SharedKeys.showAppOpen, true);

  @override
  bool getShowAppOpen() => prefs.getBool(SharedKeys.showAppOpen) ?? false;
}

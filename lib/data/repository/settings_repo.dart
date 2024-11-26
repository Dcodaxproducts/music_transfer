import 'dart:convert';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:matrix_ai/data/model/body/config_model.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/response/model.dart';
import 'settings_repo_interface.dart';

class SettingsRepo implements SettingsRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences sharedPreferences;
  SettingsRepo({
    required this.sharedPreferences,
    required this.apiClient,
  });

  @override
  ConfigModel initSharedData() {
    // negative prompt
    String negativePrompt =
        sharedPreferences.getString(AppConstants.NEGATIVE_PROMPT) ?? '';

    // guidance scale
    double guidanceScale =
        sharedPreferences.getDouble(AppConstants.GUIDANCE_SCALE) ?? 3.5;

    // aspect ratio
    int aspectRatio = sharedPreferences.getInt(AppConstants.ASPECT_RATIO) ?? 1;

    // selected model
    String? model = sharedPreferences.getString(AppConstants.SELECTED_MODEL);
    Model? selectedModel;
    if (model != null) {
      selectedModel = Model.fromJson(jsonDecode(model));
    }

    // has viewed ads dialog
    bool hasViewedAdsDialog =
        sharedPreferences.getBool(AppConstants.HAS_VIEWED_ADS_DIALOG) ?? false;

    // onboarding skip
    bool onBoardingSkip =
        sharedPreferences.getBool(AppConstants.ON_BOARDING_SKIP) ?? false;

    // notification enabled
    bool notificationEnabled =
        sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? false;

    // check if the theme, language and country code are set
    if (!sharedPreferences.containsKey(AppConstants.THEME)) {
      sharedPreferences.setString(AppConstants.THEME, 'system');
    }

    // check if the theme, language and country code are set
    if (!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      sharedPreferences.setString(
          AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }

    // check if the theme, language and country code are set
    if (!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      sharedPreferences.setString(
          AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
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
      sharedPreferences.setDouble(
        AppConstants.GUIDANCE_SCALE,
        configModel.guidanceScale,
      ),
      sharedPreferences.setInt(
        AppConstants.ASPECT_RATIO,
        configModel.aspectRatio,
      ),
      sharedPreferences.setString(
        AppConstants.SELECTED_MODEL,
        jsonEncode(configModel.selectedModel?.toJson()),
      ),
      sharedPreferences.setString(
        AppConstants.NEGATIVE_PROMPT,
        configModel.negativePrompt,
      ),
      sharedPreferences.setBool(
        AppConstants.ON_BOARDING_SKIP,
        configModel.onBoardingSkip,
      ),
      sharedPreferences.setBool(
        AppConstants.NOTIFICATION,
        configModel.notificationsEnabled,
      ),
      sharedPreferences.setBool(
        AppConstants.HAS_VIEWED_ADS_DIALOG,
        configModel.hasViewdAdsDialog,
      ),
    ]);
  }

  @override
  Future<Response?> getConfig() async =>
      await apiClient.get(AppConstants.CONFIG_URL);

  @override
  int getOpenCount() {
    int openCount = sharedPreferences.getInt(AppConstants.OPEN_COUNT) ?? 0;
    openCount++;
    sharedPreferences.setInt(AppConstants.OPEN_COUNT, openCount);
    return openCount;
  }

  @override
  Future<bool> saveFirstTime() async =>
      await sharedPreferences.setBool(AppConstants.ON_BOARDING_SKIP, false);

  @override
  bool getFirstTime() =>
      sharedPreferences.getBool(AppConstants.ON_BOARDING_SKIP) ?? true;

  @override
  Future<bool> saveShowAppOpen() async =>
      await sharedPreferences.setBool(AppConstants.SHOW_APP_OPEN, true);

  @override
  bool getShowAppOpen() =>
      sharedPreferences.getBool(AppConstants.SHOW_APP_OPEN) ?? false;
}

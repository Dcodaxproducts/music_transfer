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
  final SharedPreferences prefs;
  SettingsRepo({
    required this.prefs,
    required this.apiClient,
  });

  @override
  ConfigModel initSharedData() {
    // negative prompt
    String negativePrompt = prefs.getString(AppConstants.NEGATIVE_PROMPT) ?? '';

    // guidance scale
    double guidanceScale = prefs.getDouble(AppConstants.GUIDANCE_SCALE) ?? 3.5;

    // aspect ratio
    int aspectRatio = prefs.getInt(AppConstants.ASPECT_RATIO) ?? 1;

    // selected model
    String? model = prefs.getString(AppConstants.SELECTED_MODEL);
    Model? selectedModel;
    if (model != null) {
      selectedModel = Model.fromJson(jsonDecode(model));
    }

    // has viewed ads dialog
    bool hasViewedAdsDialog = prefs.getBool(AppConstants.HAS_VIEWED_ADS_DIALOG) ?? false;

    // onboarding skip
    bool onBoardingSkip = prefs.getBool(AppConstants.ON_BOARDING_SKIP) ?? false;

    // notification enabled
    bool notificationEnabled = prefs.getBool(AppConstants.NOTIFICATION) ?? false;

    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.THEME)) {
      prefs.setString(AppConstants.THEME, 'system');
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.COUNTRY_CODE)) {
      prefs.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }

    // check if the theme, language and country code are set
    if (!prefs.containsKey(AppConstants.LANGUAGE_CODE)) {
      prefs.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
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
      prefs.setDouble(
        AppConstants.GUIDANCE_SCALE,
        configModel.guidanceScale,
      ),
      prefs.setInt(
        AppConstants.ASPECT_RATIO,
        configModel.aspectRatio,
      ),
      prefs.setString(
        AppConstants.SELECTED_MODEL,
        jsonEncode(configModel.selectedModel?.toJson()),
      ),
      prefs.setString(
        AppConstants.NEGATIVE_PROMPT,
        configModel.negativePrompt,
      ),
      prefs.setBool(
        AppConstants.ON_BOARDING_SKIP,
        configModel.onBoardingSkip,
      ),
      prefs.setBool(
        AppConstants.NOTIFICATION,
        configModel.notificationsEnabled,
      ),
      prefs.setBool(
        AppConstants.HAS_VIEWED_ADS_DIALOG,
        configModel.hasViewdAdsDialog,
      ),
    ]);
  }

  @override
  Future<Response?> getConfig() async => await apiClient.get(AppConstants.CONFIG_URL);

  @override
  int getOpenCount() {
    int openCount = prefs.getInt(AppConstants.OPEN_COUNT) ?? 0;
    openCount++;
    prefs.setInt(AppConstants.OPEN_COUNT, openCount);
    return openCount;
  }

  @override
  Future<bool> saveFirstTime() async => await prefs.setBool(AppConstants.ON_BOARDING_SKIP, false);

  @override
  bool getFirstTime() => prefs.getBool(AppConstants.ON_BOARDING_SKIP) ?? true;

  @override
  Future<bool> saveShowAppOpen() async => await prefs.setBool(AppConstants.SHOW_APP_OPEN, true);

  @override
  bool getShowAppOpen() => prefs.getBool(AppConstants.SHOW_APP_OPEN) ?? false;
}

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
    String negativePrompt =
        sharedPreferences.getString(AppConstants.NEGATIVE_PROMPT) ?? '';
    double guidanceScale =
        sharedPreferences.getDouble(AppConstants.GUIDANCE_SCALE) ?? 7.5;
    int steps = sharedPreferences.getInt(AppConstants.STEPS) ?? 31;
    int aspectRatio = sharedPreferences.getInt(AppConstants.ASPECT_RATIO) ?? 1;
    int selectedStyle =
        sharedPreferences.getInt(AppConstants.SELECTED_STYLE) ?? 0;
    String? model = sharedPreferences.getString(AppConstants.SELECTED_MODEL);
    Model? selectedModel;
    if (model != null) {
      selectedModel = Model.fromJson(jsonDecode(model));
    }

    bool onBoardingSkip =
        sharedPreferences.getBool(AppConstants.ON_BOARDING_SKIP) ?? false;

    if (!sharedPreferences.containsKey(AppConstants.THEME)) {
      sharedPreferences.setString(AppConstants.THEME, 'system');
    }
    if (!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      sharedPreferences.setString(
          AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }
    if (!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      sharedPreferences.setString(
          AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    }

    return ConfigModel(
      onBoardingSkip: onBoardingSkip,
      guidanceScale: guidanceScale,
      steps: steps,
      aspectRatio: aspectRatio,
      selectedModel: selectedModel,
      selectedStyle: selectedStyle,
      negativePrompt: negativePrompt,
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
        AppConstants.STEPS,
        configModel.steps,
      ),
      sharedPreferences.setInt(
        AppConstants.ASPECT_RATIO,
        configModel.aspectRatio,
      ),
      sharedPreferences.setInt(
        AppConstants.SELECTED_STYLE,
        configModel.selectedStyle,
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
}

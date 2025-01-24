import 'package:matrix_ai/data/model/body/config_model.dart';
import 'package:matrix_ai/data/model/response/model.dart';
import 'package:matrix_ai/data/model/response/setting_model.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../data/service/setting_service_interface.dart';
import '../view/base/text_editing_controller.dart';

class SettingsController extends GetxController implements GetxService {
  final SettingsServiceInterface settingsService;
  SettingsController({required this.settingsService});

  static SettingsController get find => Get.find<SettingsController>();

  // Text controllers for user input
  final promptController = StyleableTextFieldController(
    styles: TextPartStyleDefinitions(
      definitionList: [],
      adultWords: AppConstants.ADULT_WORDS,
    ),
  );
  final seedController = TextEditingController();
  final negativePromptController = TextEditingController();

  // Internal state
  late ConfigModel _configModel;
  late SettingModel _settingModel;

  // Getters for accessing data in the UI
  ConfigModel get configModel => _configModel;
  SettingModel get settingModel => _settingModel;
  set configModel(ConfigModel configModel) {
    _configModel = configModel;
    settingsService.updateSharedData(_configModel);
    update();
  }

  set settingModel(SettingModel settingModel) {
    _settingModel = settingModel;
    update();
  }

  // Load initial data from service
  ConfigModel initSharedData() {
    _configModel = settingsService.initSharedData();
    negativePromptController.text = _configModel.negativePrompt;
    seedController.text = _configModel.seed == null ? '-1' : _configModel.seed!.toString();
    _isFirstTime = settingsService.getFirstTime();
    getPackageInfo();
    return _configModel;
  }

  Future<SettingModel> getSettings() async {
    _settingModel = await settingsService.getSettings();
    update();
    return _settingModel;
  }

  void setPromptText(String text) {
    promptController.text = text;
  }

  void setModel(Model model) {
    _configModel = _configModel.copyWith(selectedModel: model);
    settingsService.updateSharedData(_configModel);
    update();
  }

  bool get hasOffensiveWords {
    bool isOffensive = false;
    final textParts = promptController.text.split(' ');
    for (final textPart in textParts) {
      if (AppConstants.ADULT_WORDS.contains(removePunctuation(textPart.toLowerCase()))) {
        isOffensive = true;
        break;
      }
    }
    return isOffensive;
  }

  Future<void> saveFirstTime() async {
    _isFirstTime = false;
    update();
    await settingsService.saveFirstTime();
  }

  bool _isFirstTime = false;
  bool get isFirstTime => _isFirstTime;

  Future<bool> saveShowAppOpen() async => await settingsService.saveShowAppOpen();

  bool get showAppOpen => settingsService.getShowAppOpen();

  PackageInfo? _packageInfo;
  PackageInfo? get packageInfo => _packageInfo;

  getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    update();
  }
}

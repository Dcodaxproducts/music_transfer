import 'package:matrix_ai/data/model/body/api_langauge.dart';
import 'package:matrix_ai/data/model/body/config_model.dart';
import 'package:matrix_ai/data/model/response/model.dart';
import 'package:matrix_ai/data/model/response/setting_model.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final ApiLanguage _selectedLanguage = apiLanguageList[0];
  late ConfigModel _configModel;
  late SettingModel _settingModel;
  int _openCount = 0;

  // Getters for accessing data in the UI
  ApiLanguage get selectedLanguage => _selectedLanguage;
  ConfigModel get configModel => _configModel;
  SettingModel get settingModel => _settingModel;
  bool get isThirdTime => _openCount >= 3;
  int get openCount => _openCount;

  set configModel(ConfigModel configModel) {
    _configModel = configModel;
    settingsService.updateSharedData(_configModel);
    update();
  }

  set settingModel(SettingModel settingModel) {
    _settingModel = settingModel;
    update();
  }

  set openCount(int openCount) {
    _openCount = openCount;
    update();
  }

  // Load initial data from service
  ConfigModel initSharedData() {
    _configModel = settingsService.initSharedData();
    _openCount = settingsService.getOpenCount();
    negativePromptController.text = _configModel.negativePrompt;
    seedController.text =
        _configModel.seed == null ? '-1' : _configModel.seed!.toString();
    getSettings();
    return _configModel;
  }

  Future<void> getSettings() async {
    _settingModel = await settingsService.getSettings();
    update();
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
      if (AppConstants.ADULT_WORDS
          .contains(removePunctuation(textPart.toLowerCase()))) {
        isOffensive = true;
        break;
      }
    }
    return isOffensive;
  }
}

import 'package:pixart_app/image_gen/prompt_setting/data/model/config_model.dart';
import 'package:pixart_app/features/splash/data/model/setting_model.dart';
import 'package:pixart_app/core/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../domain/service/setting_service_interface.dart';
import '../../../home/presentation/controller/text_editing_controller.dart';

class SettingsController extends GetxController implements GetxService {
  final SettingsServiceInterface settingsService;
  SettingsController({required this.settingsService});

  static SettingsController get find => Get.find<SettingsController>();

  // Text controllers for user input
  final promptController = StyleableTextFieldController(
    styles: TextPartStyleDefinitions(definitionList: [], adultWords: AppConstants.adultWords),
  );

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
    _isFirstTime = settingsService.getFirstTime();
    getPackageInfo();
    return _configModel;
  }

  Future<SettingModel> getSettings() async {
    _settingModel = await settingsService.getSettings();
    update();
    return _settingModel;
  }



  bool get hasOffensiveWords {
    bool isOffensive = false;
    final textParts = promptController.text.split(' ');
    for (final textPart in textParts) {
      if (AppConstants.adultWords.contains(removePunctuation(textPart.toLowerCase()))) {
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

  Future<void> getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    update();
  }
}

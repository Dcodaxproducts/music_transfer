import 'dart:convert';
import 'package:http/http.dart';
import '../../data/model/config_model.dart';
import '../../../splash/data/model/setting_model.dart';
import '../../data/repository/settings_repo_interface.dart';
import 'setting_service_interface.dart';

class SettingsService implements SettingsServiceInterface {
  final SettingsRepoInterface settingsRepo;
  SettingsService({required this.settingsRepo});

  @override
  ConfigModel initSharedData() {
    return settingsRepo.initSharedData();
  }

  @override
  Future<SettingModel> getSettings() async {
    Response? response = await settingsRepo.getConfig();
    if (response != null) {
      return SettingModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load settings");
    }
  }

  @override
  Future<void> updateSharedData(ConfigModel configModel) {
    return settingsRepo.updateSharedData(configModel);
  }

  @override
  Future<bool> saveFirstTime() {
    return settingsRepo.saveFirstTime();
  }

  @override
  bool getFirstTime() {
    return settingsRepo.getFirstTime();
  }

  @override
  Future<bool> saveShowAppOpen() {
    return settingsRepo.saveShowAppOpen();
  }

  @override
  bool getShowAppOpen() {
    return settingsRepo.getShowAppOpen();
  }
}

import 'dart:convert';
import 'package:http/http.dart';
import '../model/body/config_model.dart';
import '../model/response/setting_model.dart';
import '../repository/settings_repo_interface.dart';
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
  int getOpenCount() {
    return settingsRepo.getOpenCount();
  }
}

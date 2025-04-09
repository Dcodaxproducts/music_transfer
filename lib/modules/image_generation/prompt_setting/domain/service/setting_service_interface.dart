import '../../data/model/config_model.dart';
import '../../../../../features/splash/data/model/setting_model.dart';

abstract class SettingsServiceInterface<T> {
  ConfigModel initSharedData();
  Future<void> updateSharedData(ConfigModel configModel);
  Future<SettingModel> getSettings();
  Future<bool> saveFirstTime();
  bool getFirstTime();
  Future<bool> saveShowAppOpen();
  bool getShowAppOpen();
}

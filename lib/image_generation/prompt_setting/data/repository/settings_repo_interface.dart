import 'package:pixart_app/image_generation/prompt_setting/data/model/config_model.dart';
import 'package:http/http.dart';

abstract class SettingsRepoInterface {
  ConfigModel initSharedData();
  Future<void> updateSharedData(ConfigModel configModel);
  Future<Response?> getConfig();
  int getOpenCount();
  Future<bool> saveFirstTime();
  bool getFirstTime();
  Future<bool> saveShowAppOpen();
  bool getShowAppOpen();
}

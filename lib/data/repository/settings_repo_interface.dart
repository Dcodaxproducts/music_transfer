import 'package:matrix_ai/data/model/body/config_model.dart';
import 'package:http/http.dart';

abstract class SettingsRepoInterface<T> {
  ConfigModel initSharedData();
  Future<void> updateSharedData(ConfigModel configModel);
  Future<Response?> getConfig();
  int getOpenCount();
}

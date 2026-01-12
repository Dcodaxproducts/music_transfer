import 'package:http/http.dart';

abstract class ModelsRepo {
  Future<Response?> getModels();
  Future<bool> cacheModels(String models);
  String? getCachedModels();
  Future<bool> saveSelectedModel(int modelId);
  int? getSelectedModel();
}

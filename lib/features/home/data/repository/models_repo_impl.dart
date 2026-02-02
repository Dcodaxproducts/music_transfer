import 'package:pixart_app/imports.dart';
import 'models_repo.dart';

class ModelsRepoImpl implements ModelsRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  ModelsRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<Response?> getModels() async {
    return await apiClient.get(Endpoints.models);
  }

  @override
  Future<bool> cacheModels(String models) async {
    return await prefs.setString(SharedKeys.cachedModels, models);
  }

  @override
  String? getCachedModels() {
    return prefs.getString(SharedKeys.cachedModels);
  }

  @override
  Future<bool> saveSelectedModel(int modelId) async {
    return await prefs.setInt(SharedKeys.selectedModel, modelId);
  }

  @override
  int? getSelectedModel() {
    return prefs.getInt(SharedKeys.selectedModel);
  }
}

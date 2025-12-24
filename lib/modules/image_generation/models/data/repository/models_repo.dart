import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/imports.dart';
import 'models_repo_interface.dart';

class ModelsRepo implements ModelsRepoInterface {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  ModelsRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> getModels() async {
    return await apiClient.get(Endpoints.MODELS_URL);
  }

  @override
  Future<bool> saveFavoriteModel(List<int> models) async {
    return await prefs.setStringList(SharedKeys.favoriteModels, models.map((e) => e.toString()).toList());
  }

  @override
  List<int> getFavoriteModels() {
    List<String>? list = prefs.getStringList(SharedKeys.favoriteModels);
    if (list != null) {
      return list.map((e) => int.parse(e)).toList();
    } else {
      return [];
    }
  }
}

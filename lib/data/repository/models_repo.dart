import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models_repo_interface.dart';

class ModelsRepo implements ModelsRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences sharedPreferences;
  ModelsRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<Response?> getModels() async {
    return await apiClient.get(AppConstants.MODELS_URL);
  }

  @override
  Future<bool> saveFavoriteModel(List<int> models) async {
    return await sharedPreferences.setStringList(
      AppConstants.FAVORITE_MODELS,
      models.map((e) => e.toString()).toList(),
    );
  }

  @override
  List<int> getFavoriteModels() {
    List<String>? list =
        sharedPreferences.getStringList(AppConstants.FAVORITE_MODELS);
    if (list != null) {
      return list.map((e) => int.parse(e)).toList();
    } else {
      return [];
    }
  }
}

import 'package:matrix_ai/data/api/api_client.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelsRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ModelsRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response?> getModels() async {
    return await apiClient.get(AppConstants.MODELS_URL);
  }

  saveFavoriteModel(List<int> models) async {
    return await sharedPreferences.setStringList(
      AppConstants.FAVORITE_MODELS,
      models.map((e) => e.toString()).toList(),
    );
  }

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

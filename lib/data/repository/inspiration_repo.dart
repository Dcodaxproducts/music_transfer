import 'package:matrix_ai/data/api/api_client.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspirationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  InspirationRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response?> getInspirations() async {
    return await apiClient.get(AppConstants.INSIPIRATIONS_URL);
  }
}

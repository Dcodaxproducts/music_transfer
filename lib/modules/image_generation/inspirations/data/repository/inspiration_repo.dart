import 'package:matrix_ai/core/api/api_client_interface.dart';
import 'package:matrix_ai/core/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inspiration_repo_interface.dart';

class InspirationRepo implements InspirationRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences prefs;
  InspirationRepo({
    required this.apiClient,
    required this.prefs,
  });

  @override
  Future<Response?> getInspirations() async {
    return await apiClient.get(AppConstants.INSIPIRATIONS_URL);
  }
}

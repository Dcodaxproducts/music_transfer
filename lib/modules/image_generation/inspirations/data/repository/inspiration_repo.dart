import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inspiration_repo_interface.dart';

class InspirationRepo implements InspirationRepoInterface {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  InspirationRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> getInspirations() async {
    return await apiClient.get(Endpoints.INSIPIRATIONS_URL);
  }
}

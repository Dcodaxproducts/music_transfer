import 'package:pixart_app/imports.dart';
import 'inspiration_repo.dart';

class InspirationRepoImpl implements InspirationRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  InspirationRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<Response?> getInspirations() async {
    return await apiClient.get(Endpoints.inspirations);
  }
}

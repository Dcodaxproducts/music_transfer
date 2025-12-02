import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'review_repo_interface.dart';

class ReviewRepo implements ReviewRepoInterface {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  ReviewRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> saveReview(Map<String, dynamic> body) async {
    return await apiClient.post(Endpoints.BASE_URL + Endpoints.FEEDBACK_URL, body);
  }

  @override
  Future<bool> setReviewed() async {
    return await prefs.setBool(SharedKeys.REVIEWED, true);
  }

  @override
  bool isReviewed() {
    return prefs.getBool(SharedKeys.REVIEWED) ?? false;
  }

  @override
  Future<bool> setLastDialogShowed() {
    return prefs.setString(SharedKeys.LAST_DIALOG_SHOWED, DateTime.now().toString());
  }

  @override
  String? getLastDialogShowed() {
    return prefs.getString(SharedKeys.LAST_DIALOG_SHOWED);
  }
}

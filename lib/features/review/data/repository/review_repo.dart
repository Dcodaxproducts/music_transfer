import 'package:pixart_app/imports.dart';
import 'review_repo_interface.dart';

class ReviewRepo implements ReviewRepoInterface {
  final ApiClient apiClient;
  final SharedPreferences prefs;
  ReviewRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> saveReview(Map<String, dynamic> body) async {
    return await apiClient.post(Endpoints.baseUrl + Endpoints.feedback, body);
  }

  @override
  Future<bool> setReviewed() async {
    return await prefs.setBool(SharedKeys.reviewed, true);
  }

  @override
  bool isReviewed() {
    return prefs.getBool(SharedKeys.reviewed) ?? false;
  }

  @override
  Future<bool> setLastDialogShowed() {
    return prefs.setString(SharedKeys.lastShowedDialog, DateTime.now().toString());
  }

  @override
  String? getLastDialogShowed() {
    return prefs.getString(SharedKeys.lastShowedDialog);
  }
}

import 'package:http/http.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'review_repo_interface.dart';

class ReviewRepo implements ReviewRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences prefs;
  ReviewRepo({required this.apiClient, required this.prefs});

  @override
  Future<Response?> saveReview(Map<String, dynamic> body) async {
    return await apiClient.post(AppConstants.BASE_URL + AppConstants.FEEDBACK_URL, body);
  }

  @override
  Future<bool> setReviewed() async {
    return await prefs.setBool(AppConstants.REVIEWED, true);
  }

  @override
  bool isReviewed() {
    return prefs.getBool(AppConstants.REVIEWED) ?? false;
  }

  @override
  Future<bool> setLastDialogShowed() {
    return prefs.setString(AppConstants.LAST_DIALOG_SHOWED, DateTime.now().toString());
  }

  @override
  String? getLastDialogShowed() {
    return prefs.getString(AppConstants.LAST_DIALOG_SHOWED);
  }
}

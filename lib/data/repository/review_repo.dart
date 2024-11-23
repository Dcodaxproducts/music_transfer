import 'package:http/http.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'review_repo_interface.dart';

class ReviewRepo implements ReviewRepoInterface {
  final ApiClientInterface apiClient;
  final SharedPreferences sharedPreferences;
  ReviewRepo({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response?> saveReview(Map<String, dynamic> body) async {
    return await apiClient.post(
        AppConstants.BASE_URL + AppConstants.FEEDBACK_URL, body);
  }

  @override
  Future<bool> setReviewed() async {
    return await sharedPreferences.setBool(AppConstants.REVIEWED, true);
  }

  @override
  bool isReviewed() {
    return sharedPreferences.getBool(AppConstants.REVIEWED) ?? false;
  }
}

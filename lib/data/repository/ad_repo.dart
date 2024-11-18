import 'package:http/http.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import '../../utils/app_constants.dart';
import 'ad_repo_interface.dart';

class AdRepo implements AdRepoInterface {
  final ApiClientInterface apiClient;
  AdRepo({required this.apiClient});

  @override
  Future<Response?> getAdIds() async {
    return await apiClient.get(AppConstants.GET_ADS);
  }
}

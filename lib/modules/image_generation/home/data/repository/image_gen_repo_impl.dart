import 'package:pixart_app/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/api/api_client.dart';
import 'image_gen_repo.dart';

class ImageGenRepoImpl implements ImageGenRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;

  ImageGenRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<Response?> generateImages(Map<String, dynamic> body) async {
    return await apiClient.post(
      Endpoints.generateImage,
      body,
      hideLoading: false,
    );
  }

  @override
  Future<void> cancelRequest() async {
    await apiClient.cancelRequest();
  }
}

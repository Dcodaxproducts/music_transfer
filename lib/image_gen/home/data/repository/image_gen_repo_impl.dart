import 'package:pixart_app/imports.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_client_impl.dart';
import 'image_gen_repo.dart';

class ImageGenRepoImpl implements ImageGenRepo {
  final ApiClient apiClient;
  final SharedPreferences prefs;

  ImageGenRepoImpl({required this.apiClient, required this.prefs});

  @override
  Future<Response?> generateImages(Map<String, dynamic> body, {List<MultipartBody>? files}) async {
    if (files != null && files.isNotEmpty) {
      return await apiClient.postMultipart(Endpoints.generateImage, body, files);
    }
    return await apiClient.post(Endpoints.generateImage, body);
  }

  @override
  Future<void> cancelRequest() async {
    await apiClient.cancelRequest();
  }
}

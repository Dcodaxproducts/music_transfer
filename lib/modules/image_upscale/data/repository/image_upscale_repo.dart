import 'package:http/http.dart';
import '../../../../core/api/api_client_impl.dart';
import '../model/upscale_result.dart';

abstract class ImageUpscaleRepo {
  Future<Response?> upscaleImage(
    Map<String, dynamic> body,
    MultipartBody multipartBody,
  );

  Future<bool> saveHistoryInPrefs(List<UpscaleResult> upscaleHistory);

  List<String>? getHistoryFromPrefs();
}

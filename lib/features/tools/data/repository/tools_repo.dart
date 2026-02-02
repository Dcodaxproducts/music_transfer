import 'package:http/http.dart';
import '../../../../core/api/api_client_impl.dart';

abstract class ToolsRepo {
  Future<Response?> getTools();
  Future<Response?> generateImage({
    required String endpoint,
    required Map<String, dynamic> body,
    required List<MultipartBody> multipartBodies,
  });
}
